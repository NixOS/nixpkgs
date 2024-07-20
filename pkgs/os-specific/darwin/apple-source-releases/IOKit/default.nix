{ lib, appleDerivation', stdenv, IOKitSrcs, xnu, darwin-stubs }:

# Someday it'll make sense to split these out into their own packages, but today is not that day.
appleDerivation' stdenv {
  srcs = lib.attrValues IOKitSrcs;
  sourceRoot = ".";

  __propagatedImpureHostDeps = [
    "/System/Library/Frameworks/IOKit.framework/IOKit"
    "/System/Library/Frameworks/IOKit.framework/Resources"
    "/System/Library/Frameworks/IOKit.framework/Versions"
  ];

  installPhase = ''
    mkdir -p $out/Library/Frameworks/IOKit.framework

    ###### IMPURITIES
    ln -s /System/Library/Frameworks/IOKit.framework/Resources \
      $out/Library/Frameworks/IOKit.framework

    ###### STUBS
    cp ${darwin-stubs}/System/Library/Frameworks/IOKit.framework/Versions/A/IOKit.tbd \
      $out/Library/Frameworks/IOKit.framework

    ###### HEADERS

    export dest=$out/Library/Frameworks/IOKit.framework/Headers
    mkdir -p $dest

    pushd $dest
    mkdir audio avc DV firewire graphics hid hidsystem i2c kext ndrvsupport
    mkdir network ps pwr_mgt sbp2 scsi serial storage stream usb video
    popd

    # root: complete
    cp IOKitUser-*/IOCFBundle.h                                       $dest
    cp IOKitUser-*/IOCFPlugIn.h                                       $dest
    cp IOKitUser-*/IOCFSerialize.h                                    $dest
    cp IOKitUser-*/IOCFUnserialize.h                                  $dest
    cp IOKitUser-*/IOCFURLAccess.h                                    $dest
    cp IOKitUser-*/IODataQueueClient.h                                $dest
    cp IOKitUser-*/IOKitLib.h                                         $dest
    cp IOKitUser-*/iokitmig.h                                         $dest
    cp ${xnu}/Library/PrivateFrameworks/IOKit.framework/Versions/A/Headers/*.h $dest

    # audio: complete
    cp IOAudioFamily-*/IOAudioDefines.h          $dest/audio
    cp IOKitUser-*/audio.subproj/IOAudioLib.h    $dest/audio
    cp IOAudioFamily-*/IOAudioTypes.h            $dest/audio

    # avc: complete
    cp IOFireWireAVC-*/IOFireWireAVC/IOFireWireAVCConsts.h $dest/avc
    cp IOFireWireAVC-*/IOFireWireAVCLib/IOFireWireAVCLib.h $dest/avc

    # DV: complete
    cp IOFWDVComponents-*/DVFamily.h $dest/DV

    # firewire: complete
    cp IOFireWireFamily-*/IOFireWireFamily.kmodproj/IOFireWireFamilyCommon.h $dest/firewire
    cp IOFireWireFamily-*/IOFireWireLib.CFPlugInProj/IOFireWireLib.h         $dest/firewire
    cp IOFireWireFamily-*/IOFireWireLib.CFPlugInProj/IOFireWireLibIsoch.h    $dest/firewire
    cp IOFireWireFamily-*/IOFireWireFamily.kmodproj/IOFWIsoch.h              $dest/firewire

    # graphics: missing AppleGraphicsDeviceControlUserCommand.h
    cp IOGraphics-*/IOGraphicsFamily/IOKit/graphics/IOAccelClientConnect.h     $dest/graphics
    cp IOGraphics-*/IOGraphicsFamily/IOKit/graphics/IOAccelSurfaceConnect.h    $dest/graphics
    cp IOGraphics-*/IOGraphicsFamily/IOKit/graphics/IOAccelTypes.h             $dest/graphics
    cp IOGraphics-*/IOGraphicsFamily/IOKit/graphics/IOFramebufferShared.h      $dest/graphics
    cp IOGraphics-*/IOGraphicsFamily/IOKit/graphics/IOGraphicsEngine.h         $dest/graphics
    cp IOGraphics-*/IOGraphicsFamily/IOKit/graphics/IOGraphicsInterface.h      $dest/graphics
    cp IOGraphics-*/IOGraphicsFamily/IOKit/graphics/IOGraphicsInterfaceTypes.h $dest/graphics
    cp IOKitUser-*/graphics.subproj/IOGraphicsLib.h                            $dest/graphics
    cp IOGraphics-*/IOGraphicsFamily/IOKit/graphics/IOGraphicsTypes.h          $dest/graphics

    # hid: complete
    cp IOKitUser-*/hid.subproj/IOHIDBase.h          $dest/hid
    cp IOKitUser-*/hid.subproj/IOHIDDevice.h        $dest/hid
    cp IOKitUser-*/hid.subproj/IOHIDDevicePlugIn.h  $dest/hid
    cp IOKitUser-*/hid.subproj/IOHIDElement.h       $dest/hid
    cp IOKitUser-*/hid.subproj/IOHIDLib.h           $dest/hid
    cp IOKitUser-*/hid.subproj/IOHIDManager.h       $dest/hid
    cp IOKitUser-*/hid.subproj/IOHIDQueue.h         $dest/hid
    cp IOKitUser-*/hid.subproj/IOHIDTransaction.h   $dest/hid
    cp IOKitUser-*/hid.subproj/IOHIDValue.h         $dest/hid
    cp IOHIDFamily-*/IOHIDFamily/IOHIDKeys.h        $dest/hid
    cp IOHIDFamily-*/IOHIDFamily/IOHIDUsageTables.h $dest/hid
    cp IOHIDFamily-*/IOHIDLib/IOHIDLibObsolete.h    $dest/hid

    # hidsystem: complete
    cp IOHIDFamily-*/IOHIDSystem/IOKit/hidsystem/ev_keymap.h      $dest/hidsystem
    cp IOKitUser-*/hidsystem.subproj/event_status_driver.h        $dest/hidsystem
    cp IOKitUser-*/hidsystem.subproj/IOHIDLib.h                   $dest/hidsystem
    cp IOHIDFamily-*/IOHIDSystem/IOKit/hidsystem/IOHIDParameter.h $dest/hidsystem
    cp IOHIDFamily-*/IOHIDSystem/IOKit/hidsystem/IOHIDShared.h    $dest/hidsystem
    cp IOHIDFamily-*/IOHIDSystem/IOKit/hidsystem/IOHIDTypes.h     $dest/hidsystem
    cp IOHIDFamily-*/IOHIDSystem/IOKit/hidsystem/IOLLEvent.h      $dest/hidsystem


    # i2c: complete
    cp IOGraphics-*/IOGraphicsFamily/IOKit/i2c/IOI2CInterface.h $dest/i2c

    # kext: complete
    cp IOKitUser-*/kext.subproj/KextManager.h $dest/kext

    # ndrvsupport: complete
    cp IOGraphics-*/IONDRVSupport/IOKit/ndrvsupport/IOMacOSTypes.h $dest/ndrvsupport
    cp IOGraphics-*/IONDRVSupport/IOKit/ndrvsupport/IOMacOSVideo.h $dest/ndrvsupport

    # network: complete
    cp IONetworkingFamily-*/IOEthernetController.h       $dest/network
    cp IONetworkingFamily-*/IOEthernetInterface.h        $dest/network
    cp IONetworkingFamily-*/IOEthernetStats.h            $dest/network
    cp IONetworkingFamily-*/IONetworkController.h        $dest/network
    cp IONetworkingFamily-*/IONetworkData.h              $dest/network
    cp IONetworkingFamily-*/IONetworkInterface.h         $dest/network
    cp IOKitUser-*/network.subproj/IONetworkLib.h        $dest/network
    cp IONetworkingFamily-*/IONetworkMedium.h            $dest/network
    cp IONetworkingFamily-*/IONetworkStack.h             $dest/network
    cp IONetworkingFamily-*/IONetworkStats.h             $dest/network
    cp IONetworkingFamily-*/IONetworkUserClient.h        $dest/network

    # ps: missing IOUPSPlugIn.h
    cp IOKitUser-*/ps.subproj/IOPowerSources.h $dest/ps
    cp IOKitUser-*/ps.subproj/IOPSKeys.h       $dest/ps

    # pwr_mgt: complete
    cp IOKitUser-*/pwr_mgt.subproj/IOPMKeys.h                                          $dest/pwr_mgt
    cp IOKitUser-*/pwr_mgt.subproj/IOPMLib.h                                           $dest/pwr_mgt
    cp ${xnu}/Library/PrivateFrameworks/IOKit.framework/Versions/A/Headers/pwr_mgt/*.h $dest/pwr_mgt
    cp IOKitUser-*/pwr_mgt.subproj/IOPMLibPrivate.h                                    $dest/pwr_mgt # Private

    # sbp2: complete
    cp IOFireWireSBP2-*/IOFireWireSBP2Lib/IOFireWireSBP2Lib.h $dest/sbp2

    # scsi: omitted for now

    # serial: complete
    cp IOSerialFamily-*/IOSerialFamily.kmodproj/IOSerialKeys.h $dest/serial
    cp IOSerialFamily-*/IOSerialFamily.kmodproj/ioss.h         $dest/serial

    # storage: complete
    # Needs ata subdirectory
    cp IOStorageFamily-*/IOAppleLabelScheme.h                                    $dest/storage
    cp IOStorageFamily-*/IOApplePartitionScheme.h                                $dest/storage
    cp IOBDStorageFamily-*/IOBDBlockStorageDevice.h                              $dest/storage
    cp IOBDStorageFamily-*/IOBDMedia.h                                           $dest/storage
    cp IOBDStorageFamily-*/IOBDMediaBSDClient.h                                  $dest/storage
    cp IOBDStorageFamily-*/IOBDTypes.h                                           $dest/storage
    cp IOStorageFamily-*/IOBlockStorageDevice.h                                  $dest/storage
    cp IOStorageFamily-*/IOBlockStorageDriver.h                                  $dest/storage
    cp IOCDStorageFamily-*/IOCDBlockStorageDevice.h                              $dest/storage
    cp IOCDStorageFamily-*/IOCDMedia.h                                           $dest/storage
    cp IOCDStorageFamily-*/IOCDMediaBSDClient.h                                  $dest/storage
    cp IOCDStorageFamily-*/IOCDPartitionScheme.h                                 $dest/storage
    cp IOCDStorageFamily-*/IOCDTypes.h                                           $dest/storage
    cp IODVDStorageFamily-*/IODVDBlockStorageDevice.h                            $dest/storage
    cp IODVDStorageFamily-*/IODVDMedia.h                                         $dest/storage
    cp IODVDStorageFamily-*/IODVDMediaBSDClient.h                                $dest/storage
    cp IODVDStorageFamily-*/IODVDTypes.h                                         $dest/storage
    cp IOStorageFamily-*/IOFDiskPartitionScheme.h                                $dest/storage
    cp IOStorageFamily-*/IOFilterScheme.h                                        $dest/storage
    cp IOFireWireSerialBusProtocolTransport-*/IOFireWireStorageCharacteristics.h $dest/storage
    cp IOStorageFamily-*/IOGUIDPartitionScheme.h                                 $dest/storage
    cp IOStorageFamily-*/IOMedia.h                                               $dest/storage
    cp IOStorageFamily-*/IOMediaBSDClient.h                                      $dest/storage
    cp IOStorageFamily-*/IOPartitionScheme.h                                     $dest/storage
    cp IOStorageFamily-*/IOStorage.h                                             $dest/storage
    cp IOStorageFamily-*/IOStorageCardCharacteristics.h                          $dest/storage
    cp IOStorageFamily-*/IOStorageDeviceCharacteristics.h                        $dest/storage
    cp IOStorageFamily-*/IOStorageProtocolCharacteristics.h                      $dest/storage

    # stream: missing altogether

    # usb: complete
    cp IOUSBFamily*-630.4.5/IOUSBFamily/Headers/IOUSBLib.h            $dest/usb
    cp IOUSBFamily*-630.4.5/IOUSBUserClient/Headers/IOUSBUserClient.h $dest/usb
    cp IOUSBFamily*-560.4.2/IOUSBFamily/Headers/USB.h                 $dest/usb # This file is empty in 630.4.5!
    cp IOUSBFamily*-630.4.5/IOUSBFamily/Headers/USBSpec.h             $dest/usb

    # video: missing altogether
  '';

  meta = with lib; {
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.darwin;
    license     = licenses.apple-psl20;
  };
}
