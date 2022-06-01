# HeadTrackUDP

HeadTrackUDP is a barebone companion app for HeadTrack plugin for X-Plane that use AR feature from iOS to control the cockpit view orientation.
It's intented for people too cheap to purchase something like [smoothtrack] : https://smoothtrack.app/

An Apple AR enabled device is required.

## Installation

Download and install HeadTrack plugin to your X-Plane 11 plugin folder.
[HeadTrack]: https://github.com/amyinorbit/headtrack/releases

Build HeadTrackUDP to your test device, with Xcode (my version is 13.4, iOS 15.4).
I'm using an iPhone 12 pro.

## Support

Sorry, you are pretty much on your own.
This project is a quick and dirty mashed up app mostly based of :
- [Apple Tracking and Visualizing Faces sample code] : https://developer.apple.com/documentation/arkit/content_anchors/tracking_and_visualizing_faces
- [Tobias Wissmueller's template for sending and receiving data on a UDP connection] : https://gist.github.com/twissmueller/33247fdd9ca0bd68459a953e8e1dfe8e

## Usage

Have your device and X-Plane on the same wifi network.

Enter the server ip address in the according field. This ip is found in X-Plane networking setting page, bottom left hand part of the screen.

Well, have fun.
