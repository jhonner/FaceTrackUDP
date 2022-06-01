/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Displays coordinate axes visualizing the tracked face pose (and eyes in iOS 12).
 */

import ARKit
import SceneKit

let filterFactor : Float = 0.75

struct LowPassFilterSignal {
    var value: Float
    let filterFactor: Float
    mutating func update(_ newValue: Float) {
        value = filterFactor * value + (1.0 - filterFactor) * newValue
    }
}

class TransformVisualization: NSObject, VirtualContentController {

    private var rotX = LowPassFilterSignal(value: 0, filterFactor: filterFactor)
    private var rotY = LowPassFilterSignal(value: 0, filterFactor: filterFactor)
    private var rotZ = LowPassFilterSignal(value: 0, filterFactor: filterFactor)
    
    var contentNode: SCNNode?
    
    /// - Tag: ARNodeTracking
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        // This class adds AR content only for face anchors.
        guard anchor is ARFaceAnchor else { return nil }
        
        // Load an asset from the app bundle to provide visual content for the anchor.
        contentNode = SCNReferenceNode(named: "coordinateOrigin")
                
        // Provide the node to ARKit for keeping in sync with the face anchor.
        return contentNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) -> Data {
                    
        let rotation = anchor.transform.eulerAngles;
        let position = anchor.transform.translation;
                
        rotX.update(rotation.x)
        rotY.update(rotation.y)
        rotZ.update(rotation.z)
        
        let _rotation = V3Double(x: Double(-rotX.value), y: Double(rotY.value), z: Double(rotZ.value))
        let _position = V3Double(x: Double(position.x), y: Double(position.y), z: Double(position.z))
                     
        var data = Data()
                
        data.append(contentsOf: _position.x.bytes)
        data.append(contentsOf: _position.y.bytes)
        data.append(contentsOf: _position.z.bytes)
        data.append(contentsOf: _rotation.y.bytes)
        data.append(contentsOf: _rotation.z.bytes)
        data.append(contentsOf: _rotation.x.bytes)
        
        return data
    }
}

extension matrix_float4x4 {
    // Function to convert rad to deg
    func radiansToDegress(radians: Float32) -> Float32 {
        return radians * 180 / (Float32.pi)
    }
    var translation: SCNVector3 {
        get {
            return SCNVector3Make(columns.3.x, columns.3.y, columns.3.z)
        }
    }
    // Retrieve euler angles from a quaternion matrix
    var eulerAngles: SCNVector3 {
        get {
            // Get quaternions
            let qw = sqrt(1 + self.columns.0.x + self.columns.1.y + self.columns.2.z) / 2.0
            let qx = (self.columns.2.y - self.columns.1.z) / (qw * 4.0)
            let qy = (self.columns.0.z - self.columns.2.x) / (qw * 4.0)
            let qz = (self.columns.1.x - self.columns.0.y) / (qw * 4.0)
            
            // Deduce euler angles
            /// yaw (z-axis rotation)
            let siny = +2.0 * (qw * qz + qx * qy)
            let cosy = +1.0 - 2.0 * (qy * qy + qz * qz)
            let yaw = radiansToDegress(radians:atan2(siny, cosy))
            
            // pitch (y-axis rotation)
            let sinp = +2.0 * (qw * qy - qz * qx)
            var pitch: Float
            if abs(sinp) >= 1 {
                pitch = radiansToDegress(radians:copysign(Float.pi / 2, sinp))
            } else {
                pitch = radiansToDegress(radians:asin(sinp))
            }
            /// roll (x-axis rotation)
            let sinr = +2.0 * (qw * qx + qy * qz)
            let cosr = +1.0 - 2.0 * (qx * qx + qy * qy)
            let roll = radiansToDegress(radians:atan2(sinr, cosr))
            
            /// return array containing ypr values
            return SCNVector3(yaw, pitch, roll)
        }
    }
}
