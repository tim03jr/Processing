//Simple OpenNI options

import SimpleOpenNI.*;

SimpleOpenNI context;

context = new SimpleOpenNI(this);

context.enableDepth();

context.setMirror(false);

context.enableHand();

context.startGesture(SimpleOpenNI.GESTURE_WAVE);

context.setSmoothingHands(.5);

context.update();

int[]   depthMap = context.depthMap();

context.depthHeight()

context.depthWidth()

PVector realWorldPoint = context.depthMapRealWorld()[index];

vertex(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z);

if(handPathList.size() > 0)

context.drawCamFrustum();

void onNewHand(SimpleOpenNI curContext,int handId,PVector pos)

handPathList.put(handId,vecList);

void onTrackedHand(SimpleOpenNI curContext,int handId,PVector pos)

void onLostHand(SimpleOpenNI curContext,int handId)

handPathList.remove(handId);
