//
//  MHAudio.mm
//  Grabbr
//
//  Created by Theo LUBERT on 4/6/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#include <iostream>
#include <fstream>
#include <math.h>
#include <vector>
#include <Carbon/Carbon.h>
#include <AudioToolbox/AudioFile.h>
#include <AudioUnit/AudioUnit.h>
#include "AudioTee.hpp"
#import "MHAudio.hpp"


bool mIsRecording;
UInt32 mTagForToggleRecord;
UInt32 mTagForHistoryRecord;
UInt32 mTagForQuit;
//EventHandlerUPP recordHotKeyFunction;
//EventHandlerUPP historyRecordHotKeyFunction;
Float32 mStashedVolume;
Float32 mStashedVolume2;
AudioDeviceID mStashedAudioDeviceID;
AudioDeviceID mWavTapDeviceID;
AudioDeviceID mOutputDeviceID;
std::vector<Device> *mDevices;

@implementation MHAudio

- (id)init {
    mTagForToggleRecord = 1;
    mTagForHistoryRecord = 2;
    mTagForQuit = 3;
    mIsRecording = NO;
    mDevices = new std::vector<Device>();
    mOutputDeviceID = 0;
    mWavTapDeviceID = 0;
    return self;
}

- (void)rebuildDeviceList{
    if (mDevices) mDevices->clear();
    UInt32 propsize;
    AudioObjectPropertyAddress theAddress = { kAudioHardwarePropertyDevices, kAudioObjectPropertyScopeGlobal, kAudioObjectPropertyElementMaster };
    AudioObjectGetPropertyDataSize(kAudioObjectSystemObject, &theAddress, 0, NULL,&propsize);
    int nDevices = propsize / sizeof(AudioDeviceID);
    AudioDeviceID *devids = new AudioDeviceID[nDevices];
    AudioObjectGetPropertyData(kAudioObjectSystemObject, &theAddress, 0, NULL, &propsize, devids);
    for (int i = 0; i < nDevices; ++i) {
        int mInputs = 2;
        AudioDevice dev(devids[i], mInputs);
        Device d;
        d.mID = devids[i];
        propsize = sizeof(d.mName);
        AudioObjectPropertyAddress addr = { kAudioDevicePropertyDeviceName, (dev.mIsInput ? kAudioDevicePropertyScopeInput : kAudioDevicePropertyScopeOutput), 0 };
        AudioObjectGetPropertyData(dev.mID, &addr, 0, NULL,  &propsize, &d.mName);
        mDevices->push_back(d);
    }
    delete[] devids;
}

- (void)initConnections {
    [self rebuildDeviceList];
    for (std::vector<Device>::iterator i = mDevices->begin(); i != mDevices->end(); ++i) {
        if (0 == strcmp("Grabbr", (*i).mName)) mWavTapDeviceID = (*i).mID;
    }
    
    Float32 maxVolume = 1.0;
    UInt32 size = sizeof(mStashedAudioDeviceID);
    AudioObjectPropertyAddress devCurrDefAddress = { kAudioHardwarePropertyDefaultOutputDevice, kAudioObjectPropertyScopeGlobal, kAudioObjectPropertyElementMaster };
    AudioObjectGetPropertyData(kAudioObjectSystemObject, &devCurrDefAddress, 0, NULL, &size, &mStashedAudioDeviceID);
    mOutputDeviceID = mStashedAudioDeviceID;
    AudioObjectPropertyAddress volCurrDef1Address = { kAudioDevicePropertyVolumeScalar, kAudioObjectPropertyScopeOutput, 1 };
    size = sizeof(mStashedVolume);
    AudioObjectGetPropertyData(mStashedAudioDeviceID, &volCurrDef1Address, 0, NULL, &size, &mStashedVolume);
    AudioObjectPropertyAddress volCurrDef2Address = { kAudioDevicePropertyVolumeScalar, kAudioObjectPropertyScopeOutput, 2 };
    size = sizeof(mStashedVolume2);
    AudioObjectGetPropertyData(mStashedAudioDeviceID, &volCurrDef2Address, 0, NULL, &size, &mStashedVolume2);
    mEngine = new AudioTee(mWavTapDeviceID, mOutputDeviceID);
    AudioObjectPropertyAddress volSwapWav0Address = { kAudioDevicePropertyVolumeScalar, kAudioObjectPropertyScopeOutput, 0 };
    AudioObjectSetPropertyData(mWavTapDeviceID, &volSwapWav0Address, 0, NULL, sizeof(maxVolume), &maxVolume);
    AudioObjectPropertyAddress volSwapWav1Address = { kAudioDevicePropertyVolumeScalar, kAudioObjectPropertyScopeOutput, 1 };
    AudioObjectSetPropertyData(mWavTapDeviceID, &volSwapWav1Address, 0, NULL, sizeof(maxVolume), &maxVolume);
    AudioObjectPropertyAddress volSwapWav2Address = { kAudioDevicePropertyVolumeScalar, kAudioObjectPropertyScopeOutput, 2 };
    AudioObjectSetPropertyData(mWavTapDeviceID, &volSwapWav2Address, 0, NULL, sizeof(maxVolume), &maxVolume);
    mEngine->start();
    AudioObjectSetPropertyData(kAudioObjectSystemObject, &devCurrDefAddress, 0, NULL, sizeof(mWavTapDeviceID), &mWavTapDeviceID);
}

- (OSStatus)restoreSystemOutputDevice {
    OSStatus err = noErr;
    AudioObjectPropertyAddress devAddress = { kAudioHardwarePropertyDefaultOutputDevice, kAudioObjectPropertyScopeGlobal, kAudioObjectPropertyElementMaster };
    err = AudioObjectSetPropertyData(kAudioObjectSystemObject, &devAddress, 0, NULL, sizeof(mStashedAudioDeviceID), &mStashedAudioDeviceID);
    return err;
}

- (void)cleanupOnBeforeQuit {
    if(mEngine) mEngine->stop();
    [self restoreSystemOutputDevice];
}

@end
