ardrone-kinect
==============

Tools for flying an ARDrone using a kinect controller.

Dependencies
============

* Processing - (We are using 1.5 and not 2.x)
* Kinect Drivers for your platform (See simple-openni below for instructions)
* SimpleOpenNI Processing library for Kinect - http://code.google.com/p/simple-openni/wiki/Installation
* AR Drone Processing Libraries - https://github.com/shigeodayo/ARDroneForP5 
Documentation is at http://kougaku-navi.net/ARDroneForP5/index_en.html#library
* IMPORTANT NOTE: The newest version (Feb 2013) of the ARDroneForP5 library supports ARDrone 2.0, which our club is now using. The downloads mentioned in https://github.com/shigeodayo/ARDroneForP5#requirements have already been added to the code here, but you may need to re-add them (or symlink the code folder) if you are creating a new file/folder.

Testing and Troubleshooting
===========================

If you are having issues or you just want to make sure that you installed the libraries correctly, try some of the Example sketches that come with the ARDrone and the openNI libraries. In processing the examples should be available under File -> Examples, then scroll down to "Contributed Libraries" and you should see the ARDroneForP5 folder and the SimpleOpenNI folders. If you don't see them, restart processsing first and try again. If you still don't see one or the other, make sure that you've installed both libraries in the correct place (See processing documentation)

Things you can test are:

1. Control the ARDrone (without the kinect) using your laptop keys with the ARDroneForP5_Move3D example. If this works for you, then your drone setup should be good.

2. Make sure the kinect can see your skeleton, well your virtual one at least.  The example sketch is SimpleOpenNI -> OpenNI -> User3D.  Hold your hands up like you're under arrest and the sketch should recognize you and show a red skeleton based one where it thinks your hands, feed, and head are. 

3. Make sure you are kinected to the drone over wifi and that the kinect is plugged into the same computer.

4. Make sure the drone is ready to fly and doesn't have any faults. You may have to stop the sketch, unplug and replug the drone battery first, and then wait for the wifi to connect, and THEN start the sketch. If you don't do it in that oder, the sketch will probably throw an error and you'll have to start over.

5. Make sure that you've got another personal to hopefully keep the drone out of trouble. We make NO WARRANTY and are not repsonsible for what happens either to your drone or anything else. Practice first with the interface to get the hang of the controls without the drone and when you start with the drone, move slowly and land it often to avoid sticky situations.

6. Remember, Kinects don't really work outside (in the daylight) because of the way it works, so you'll be flying indoors, make sure that you have enough open space.

Instructions to fly
====================

VIDEO EXAMPLE: http://www.youtube.com/watch?v=4DDwqv8xScY

1. Review the dependencies and the testing and troubleshooting sections before you do anything.

2. After you've connected to the drone over wifi, and are ready to fly immediatley (sometimes it may just take off), start the sketch...

3. You should see a red screen, and after a couple seconds, you should see the kinect's camera come up. Stand in front of the camera, about 4-6 feet away and raise your arms to the sides of your head like you are pretending to be a cactus. The kinect uses this pose to recognize a user. Once you do you should see two barbell looking controllers flying above your hands. This is on the screen, not in reality. We haven't figured out how to actually make barbells do this yet. 

2. As you move your hands around, the controllers will follow your movements. To takeoff you need to change to flight mode by bringing your hands together and then extending them back out again. The controllers will activiate and create a virtual device platform between the controllers (Think of pulling out a sheet of tinfoil) which you will use to control the drone. Be prepared because the drone will immediately takeoff as well!

The Basic controls are intended to be as natural as posssible. If you practice with the controller before you fly you should get the idea, but the details are as as follows:


* ***TAKEOFF/LAND*** - Bring your hands together to enable and disable the controllers.
* ***UP/DOWN*** - Raise and lower your arms.
* ***LEFT/RIGHT*** - Raise one arm over the other. Think holding a slinky.
* ***FORWARD/BACK*** - Move your hands forward in front of your body or bring them in close (or even behind).
* ***TURN LEFT/RIGHT*** - Move one hand out in front of the other.
* ***"L" Key*** - This is basically an emergency off. It forgets the user and sends the landing command to the drone. To reconnect a new user, you have to hold your hands up again.

We hope others enjoy what we put together and will to improve it even more (right now, it's still kinda rough, but functional) . Special thanks to Adam Simone who did almost all of the work for the controller interface. Also a big thanks to the open source projects that we used for the underlying libraries.

