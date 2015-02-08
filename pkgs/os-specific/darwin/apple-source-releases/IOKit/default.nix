{ stdenv, appleDerivation, IOKitSrcs, xnu }:

# Someday it'll make sense to split these out into their own packages, but today is not that day.
appleDerivation {
  srcs = stdenv.lib.attrValues IOKitSrcs;
  sourceRoot = ".";

  phases = [ "unpackPhase" "installPhase" ];

  __propagatedImpureHostDeps = [
    "/System/Library/Frameworks/IOKit.framework/IOKit"
    "/System/Library/Frameworks/IOKit.framework/Resources"
    "/System/Library/Frameworks/IOKit.framework/Versions"
  ];

  installPhase = ''
    ###### IMPURITIES
    mkdir -p $out/Library/Frameworks/IOKit.framework
    pushd $out/Library/Frameworks/IOKit.framework
    ln -s /System/Library/Frameworks/IOKit.framework/IOKit
    ln -s /System/Library/Frameworks/IOKit.framework/Resources
    popd

    ###### HEADERS

    export dest=$out/Library/Frameworks/IOKit.framework/Headers
    mkdir -p $dest

    pushd $dest
    mkdir audio avc DV firewire graphics hid hidsystem i2c kext ndrvsupport
    mkdir network ps pwr_mgt sbp2 scsi serial storage stream usb video
    popd

    # root: complete
    cp IOKitUser-907.100.13/IOCFBundle.h                                       $dest
    cp IOKitUser-907.100.13/IOCFPlugIn.h                                       $dest
    cp IOKitUser-907.100.13/IOCFSerialize.h                                    $dest
    cp IOKitUser-907.100.13/IOCFUnserialize.h                                  $dest
    cp IOKitUser-907.100.13/IOCFURLAccess.h                                    $dest
    cp IOKitUser-907.100.13/IODataQueueClient.h                                $dest
    cp IOKitUser-907.100.13/IOKitLib.h                                         $dest
    cp IOKitUser-907.100.13/iokitmig.h                                         $dest
    cp ${xnu}/Library/PrivateFrameworks/IOKit.framework/Versions/A/Headers/*.h $dest

    # audio: complete
    cp IOAudioFamily-197.4.2/IOAudioDefines.h          $dest/audio
    cp IOKitUser-907.100.13/audio.subproj/IOAudioLib.h $dest/audio
    cp IOAudioFamily-197.4.2/IOAudioTypes.h            $dest/audio

    # avc: complete
    cp IOFireWireAVC-422.4.0/IOFireWireAVC/IOFireWireAVCConsts.h $dest/avc
    cp IOFireWireAVC-422.4.0/IOFireWireAVCLib/IOFireWireAVCLib.h $dest/avc

    # DV: complete
    cp IOFWDVComponents-207.4.1/DVFamily.h $dest/DV

    # firewire: complete
    cp IOFireWireFamily-455.4.0/IOFireWireFamily.kmodproj/IOFireWireFamilyCommon.h $dest/firewire
    cp IOFireWireFamily-455.4.0/IOFireWireLib.CFPlugInProj/IOFireWireLib.h         $dest/firewire
    cp IOFireWireFamily-455.4.0/IOFireWireLib.CFPlugInProj/IOFireWireLibIsoch.h    $dest/firewire
    cp IOFireWireFamily-455.4.0/IOFireWireFamily.kmodproj/IOFWIsoch.h              $dest/firewire

    # graphics: missing AppleGraphicsDeviceControlUserCommand.h
    cp IOGraphics-471.92.1/IOGraphicsFamily/IOKit/graphics/IOAccelClientConnect.h     $dest/graphics
    cp IOGraphics-471.92.1/IOGraphicsFamily/IOKit/graphics/IOAccelSurfaceConnect.h    $dest/graphics
    cp IOGraphics-471.92.1/IOGraphicsFamily/IOKit/graphics/IOAccelTypes.h             $dest/graphics
    cp IOGraphics-471.92.1/IOGraphicsFamily/IOKit/graphics/IOFramebufferShared.h      $dest/graphics
    cp IOGraphics-471.92.1/IOGraphicsFamily/IOKit/graphics/IOGraphicsEngine.h         $dest/graphics
    cp IOGraphics-471.92.1/IOGraphicsFamily/IOKit/graphics/IOGraphicsInterface.h      $dest/graphics
    cp IOGraphics-471.92.1/IOGraphicsFamily/IOKit/graphics/IOGraphicsInterfaceTypes.h $dest/graphics
    cp IOKitUser-907.100.13/graphics.subproj/IOGraphicsLib.h                          $dest/graphics
    cp IOGraphics-471.92.1/IOGraphicsFamily/IOKit/graphics/IOGraphicsTypes.h          $dest/graphics

    # hid: complete
    cp IOKitUser-907.100.13/hid.subproj/IOHIDBase.h         $dest/hid
    cp IOKitUser-907.100.13/hid.subproj/IOHIDDevice.h       $dest/hid
    cp IOKitUser-907.100.13/hid.subproj/IOHIDDevicePlugIn.h $dest/hid
    cp IOKitUser-907.100.13/hid.subproj/IOHIDElement.h      $dest/hid
    cp IOKitUser-907.100.13/hid.subproj/IOHIDLib.h          $dest/hid
    cp IOKitUser-907.100.13/hid.subproj/IOHIDManager.h      $dest/hid
    cp IOKitUser-907.100.13/hid.subproj/IOHIDQueue.h        $dest/hid
    cp IOKitUser-907.100.13/hid.subproj/IOHIDTransaction.h  $dest/hid
    cp IOKitUser-907.100.13/hid.subproj/IOHIDValue.h        $dest/hid
    cp IOHIDFamily-503.215.2/IOHIDFamily/IOHIDKeys.h        $dest/hid
    cp IOHIDFamily-503.215.2/IOHIDFamily/IOHIDUsageTables.h $dest/hid
    cp IOHIDFamily-503.215.2/IOHIDLib/IOHIDLibObsolete.h    $dest/hid

    # hidsystem: complete
    cp IOHIDFamily-503.215.2/IOHIDSystem/IOKit/hidsystem/ev_keymap.h      $dest/hidsystem
    cp IOKitUser-907.100.13/hidsystem.subproj/event_status_driver.h       $dest/hidsystem
    cp IOKitUser-907.100.13/hidsystem.subproj/IOHIDLib.h                  $dest/hidsystem
    cp IOHIDFamily-503.215.2/IOHIDSystem/IOKit/hidsystem/IOHIDParameter.h $dest/hidsystem
    cp IOHIDFamily-503.215.2/IOHIDSystem/IOKit/hidsystem/IOHIDShared.h    $dest/hidsystem
    cp IOHIDFamily-503.215.2/IOHIDSystem/IOKit/hidsystem/IOHIDTypes.h     $dest/hidsystem
    cp IOHIDFamily-503.215.2/IOHIDSystem/IOKit/hidsystem/IOLLEvent.h      $dest/hidsystem


    # i2c: complete
    cp IOGraphics-471.92.1/IOGraphicsFamily/IOKit/i2c/IOI2CInterface.h $dest/i2c

    # kext: complete
    cp IOKitUser-907.100.13/kext.subproj/KextManager.h $dest/kext

    # ndrvsupport: complete
    cp IOGraphics-471.92.1/IONDRVSupport/IOKit/ndrvsupport/IOMacOSTypes.h $dest/ndrvsupport
    cp IOGraphics-471.92.1/IONDRVSupport/IOKit/ndrvsupport/IOMacOSVideo.h $dest/ndrvsupport

    # network: complete
    cp IONetworkingFamily-100/IOEthernetController.h       $dest/network
    cp IONetworkingFamily-100/IOEthernetInterface.h        $dest/network
    cp IONetworkingFamily-100/IOEthernetStats.h            $dest/network
    cp IONetworkingFamily-100/IONetworkController.h        $dest/network
    cp IONetworkingFamily-100/IONetworkData.h              $dest/network
    cp IONetworkingFamily-100/IONetworkInterface.h         $dest/network
    cp IOKitUser-907.100.13/network.subproj/IONetworkLib.h $dest/network
    cp IONetworkingFamily-100/IONetworkMedium.h            $dest/network
    cp IONetworkingFamily-100/IONetworkStack.h             $dest/network
    cp IONetworkingFamily-100/IONetworkStats.h             $dest/network
    cp IONetworkingFamily-100/IONetworkUserClient.h        $dest/network

    # ps: missing IOUPSPlugIn.h
    cp IOKitUser-907.100.13/ps.subproj/IOPowerSources.h $dest/ps
    cp IOKitUser-907.100.13/ps.subproj/IOPSKeys.h       $dest/ps

    # pwr_mgt: complete
    cp IOKitUser-907.100.13/pwr_mgt.subproj/IOPMKeys.h                                 $dest/pwr_mgt
    cp IOKitUser-907.100.13/pwr_mgt.subproj/IOPMLib.h                                  $dest/pwr_mgt
    cp ${xnu}/Library/PrivateFrameworks/IOKit.framework/Versions/A/Headers/pwr_mgt/*.h $dest/pwr_mgt
    cp IOKitUser-907.100.13/pwr_mgt.subproj/IOPMLibPrivate.h                           $dest/pwr_mgt # Private

    # sbp2: complete
    cp IOFireWireSBP2-426.4.1/IOFireWireSBP2Lib/IOFireWireSBP2Lib.h $dest/sbp2

    # scsi: omitted for now

    # serial: complete
    cp IOSerialFamily-64.1.1/IOSerialFamily.kmodproj/IOSerialKeys.h $dest/serial
    cp IOSerialFamily-64.1.1/IOSerialFamily.kmodproj/ioss.h         $dest/serial

    # storage: complete
    # Needs ata subdirectory
    cp IOStorageFamily-172/IOAppleLabelScheme.h                                        $dest/storage
    cp IOStorageFamily-172/IOApplePartitionScheme.h                                    $dest/storage
    cp IOBDStorageFamily-14/IOBDBlockStorageDevice.h                                   $dest/storage
    cp IOBDStorageFamily-14/IOBDMedia.h                                                $dest/storage
    cp IOBDStorageFamily-14/IOBDMediaBSDClient.h                                       $dest/storage
    cp IOBDStorageFamily-14/IOBDTypes.h                                                $dest/storage
    cp IOStorageFamily-172/IOBlockStorageDevice.h                                      $dest/storage
    cp IOStorageFamily-172/IOBlockStorageDriver.h                                      $dest/storage
    cp IOCDStorageFamily-51/IOCDBlockStorageDevice.h                                   $dest/storage
    cp IOCDStorageFamily-51/IOCDMedia.h                                                $dest/storage
    cp IOCDStorageFamily-51/IOCDMediaBSDClient.h                                       $dest/storage
    cp IOCDStorageFamily-51/IOCDPartitionScheme.h                                      $dest/storage
    cp IOCDStorageFamily-51/IOCDTypes.h                                                $dest/storage
    cp IODVDStorageFamily-35/IODVDBlockStorageDevice.h                                 $dest/storage
    cp IODVDStorageFamily-35/IODVDMedia.h                                              $dest/storage
    cp IODVDStorageFamily-35/IODVDMediaBSDClient.h                                     $dest/storage
    cp IODVDStorageFamily-35/IODVDTypes.h                                              $dest/storage
    cp IOStorageFamily-172/IOFDiskPartitionScheme.h                                    $dest/storage
    cp IOStorageFamily-172/IOFilterScheme.h                                            $dest/storage
    cp IOFireWireSerialBusProtocolTransport-251.0.1/IOFireWireStorageCharacteristics.h $dest/storage
    cp IOStorageFamily-172/IOGUIDPartitionScheme.h                                     $dest/storage
    cp IOStorageFamily-172/IOMedia.h                                                   $dest/storage
    cp IOStorageFamily-172/IOMediaBSDClient.h                                          $dest/storage
    cp IOStorageFamily-172/IOPartitionScheme.h                                         $dest/storage
    cp IOStorageFamily-172/IOStorage.h                                                 $dest/storage
    cp IOStorageFamily-172/IOStorageCardCharacteristics.h                              $dest/storage
    cp IOStorageFamily-172/IOStorageDeviceCharacteristics.h                            $dest/storage
    cp IOStorageFamily-172/IOStorageProtocolCharacteristics.h                          $dest/storage

    # stream: missing altogether

    # usb: complete
    cp IOUSBFamily-630.4.5/IOUSBFamily/Headers/IOUSBLib.h            $dest/usb
    cp IOUSBFamily-630.4.5/IOUSBUserClient/Headers/IOUSBUserClient.h $dest/usb
    cp IOUSBFamily-560.4.2/IOUSBFamily/Headers/USB.h                 $dest/usb # This file is empty in 630.4.5!
    cp IOUSBFamily-630.4.5/IOUSBFamily/Headers/USBSpec.h             $dest/usb

    # video: missing altogether
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ joelteon copumpkin ];
    platforms   = platforms.darwin;
    license     = licenses.apsl20;
  };
}
