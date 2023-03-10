{ lib, stdenv, appleDerivation', launchd, bootstrap_cmds, xnu, ppp, IOKit, eap8021x, Security
, headersOnly ? false }:

appleDerivation' stdenv {
  meta.broken = stdenv.cc.nativeLibc;

  nativeBuildInputs = lib.optionals (!headersOnly) [ bootstrap_cmds ];
  buildInputs = lib.optionals (!headersOnly) [ launchd ppp IOKit eap8021x ];

  propagatedBuildInputs = lib.optionals (!headersOnly) [ Security ];

  patchPhase = lib.optionalString (!headersOnly) ''
    HACK=$PWD/hack
    mkdir $HACK
    cp -r ${xnu}/Library/Frameworks/System.framework/Versions/B/PrivateHeaders/net $HACK


    substituteInPlace SystemConfiguration.fproj/SCNetworkReachabilityInternal.h \
      --replace '#include <xpc/xpc.h>' ""

    substituteInPlace SystemConfiguration.fproj/SCNetworkReachability.c \
      --replace ''$'#define\tHAVE_VPN_STATUS' ""

    substituteInPlace SystemConfiguration.fproj/reachability/SCNetworkReachabilityServer_client.c \
      --replace '#include <xpc/xpc.h>' '#include "fake_xpc.h"' \
      --replace '#include <xpc/private.h>' "" \

    # Our neutered CoreFoundation doesn't have this function, but I think we'll live...
    substituteInPlace SystemConfiguration.fproj/SCNetworkConnectionPrivate.c \
      --replace 'CFPreferencesAppValueIsForced(serviceID, USER_PREFERENCES_APPLICATION_ID)' 'FALSE' \
      --replace 'CFPreferencesAppValueIsForced(userPrivate->serviceID, USER_PREFERENCES_APPLICATION_ID)' 'FALSE'

    cat >SystemConfiguration.fproj/fake_xpc.h <<EOF
    typedef void *xpc_type_t;
    typedef void *xpc_object_t;
    typedef void *xpc_connection_t;

    xpc_type_t xpc_get_type(xpc_object_t object);
    xpc_object_t xpc_dictionary_create(const char * const *keys, const xpc_object_t *values, size_t count);
    char *xpc_copy_description(xpc_object_t object);
    int64_t  xpc_dictionary_get_int64(xpc_object_t xdict, const char *key);
    uint64_t xpc_dictionary_get_uint64(xpc_object_t xdict, const char *key);
    void xpc_connection_set_event_handler(xpc_connection_t connection, void *handler);

    extern const struct _xpc_type_s _xpc_type_error;
    #define XPC_TYPE_ERROR (&_xpc_type_error)

    extern const struct _xpc_type_s _xpc_type_dictionary;
    #define XPC_TYPE_DICTIONARY (&_xpc_type_dictionary)

    extern const struct _xpc_type_s _xpc_type_array;
    #define XPC_TYPE_ARRAY (&_xpc_type_array)

    extern const struct _xpc_dictionary_s _xpc_error_connection_interrupted;
    #define XPC_ERROR_CONNECTION_INTERRUPTED (&_xpc_error_connection_interrupted)

    extern const struct _xpc_dictionary_s _xpc_error_connection_invalid;
    #define XPC_ERROR_CONNECTION_INVALID (&_xpc_error_connection_invalid)

    extern const char *const _xpc_error_key_description;
    #define XPC_ERROR_KEY_DESCRIPTION _xpc_error_key_description

    #define XPC_CONNECTION_MACH_SERVICE_PRIVILEGED (1 << 1)
    EOF
  '';

  dontBuild = headersOnly;

  buildPhase = ''
    pushd SystemConfiguration.fproj >/dev/null

    mkdir -p SystemConfiguration.framework/Resources
    cp ../get-mobility-info       SystemConfiguration.framework/Resources
    cp Info.plist                 SystemConfiguration.framework/Resources
    cp -r English.lproj           SystemConfiguration.framework/Resources
    cp NetworkConfiguration.plist SystemConfiguration.framework/Resources

    mkdir -p SystemConfiguration.framework/Headers
    mkdir -p SystemConfiguration.framework/PrivateHeaders

    # The standard public headers
    cp SCSchemaDefinitions.h        SystemConfiguration.framework/Headers
    cp SystemConfiguration.h        SystemConfiguration.framework/Headers
    cp SCDynamicStore.h             SystemConfiguration.framework/Headers
    cp SCDynamicStoreCopySpecific.h SystemConfiguration.framework/Headers
    cp SCPreferences.h              SystemConfiguration.framework/Headers
    cp CaptiveNetwork.h             SystemConfiguration.framework/Headers
    cp SCPreferencesPath.h          SystemConfiguration.framework/Headers
    cp SCDynamicStoreKey.h          SystemConfiguration.framework/Headers
    cp SCPreferencesSetSpecific.h   SystemConfiguration.framework/Headers
    cp SCNetworkConfiguration.h     SystemConfiguration.framework/Headers
    cp SCNetworkConnection.h        SystemConfiguration.framework/Headers
    cp SCNetworkReachability.h      SystemConfiguration.framework/Headers
    cp DHCPClientPreferences.h      SystemConfiguration.framework/Headers
    cp SCNetwork.h                  SystemConfiguration.framework/Headers
    cp SCDynamicStoreCopyDHCPInfo.h SystemConfiguration.framework/Headers

    # TODO: Do we want to preserve private headers or just make them public?
    cp SCDPlugin.h                         SystemConfiguration.framework/PrivateHeaders
    cp SCPrivate.h                         SystemConfiguration.framework/PrivateHeaders
    cp SCDynamicStorePrivate.h             SystemConfiguration.framework/PrivateHeaders
    cp SCDynamicStoreCopySpecificPrivate.h SystemConfiguration.framework/PrivateHeaders
    cp SCDynamicStoreSetSpecificPrivate.h  SystemConfiguration.framework/PrivateHeaders
    cp SCValidation.h                      SystemConfiguration.framework/PrivateHeaders
    cp SCPreferencesPrivate.h              SystemConfiguration.framework/PrivateHeaders
    cp DeviceOnHold.h                      SystemConfiguration.framework/PrivateHeaders
    cp LinkConfiguration.h                 SystemConfiguration.framework/PrivateHeaders
    cp SCPreferencesPathKey.h              SystemConfiguration.framework/PrivateHeaders
    cp SCPreferencesSetSpecificPrivate.h   SystemConfiguration.framework/PrivateHeaders
    cp SCNetworkConnectionPrivate.h        SystemConfiguration.framework/PrivateHeaders
    cp SCPreferencesGetSpecificPrivate.h   SystemConfiguration.framework/PrivateHeaders
    cp SCSchemaDefinitionsPrivate.h        SystemConfiguration.framework/PrivateHeaders
    cp SCNetworkConfigurationPrivate.h     SystemConfiguration.framework/PrivateHeaders
    cp SCPreferencesKeychainPrivate.h      SystemConfiguration.framework/PrivateHeaders
    cp SCNetworkSignature.h                SystemConfiguration.framework/PrivateHeaders
    cp SCNetworkSignaturePrivate.h         SystemConfiguration.framework/PrivateHeaders
    cp VPNPrivate.h                        SystemConfiguration.framework/PrivateHeaders
    cp VPNConfiguration.h                  SystemConfiguration.framework/PrivateHeaders
    cp VPNTunnelPrivate.h                  SystemConfiguration.framework/PrivateHeaders
    cp VPNTunnel.h                         SystemConfiguration.framework/PrivateHeaders

    mkdir derived

    cat >derived/SystemConfiguration_vers.c <<EOF
    const unsigned char SystemConfigurationVersionString[] __attribute__ ((used)) = "@(#)PROGRAM:SystemConfiguration  PROJECT:configd-" "\n"; const double SystemConfigurationVersionNumber __attribute__ ((used)) = (double)0.;
    EOF

    mig -arch x86_64 -header derived/shared_dns_info.h -user derived/shared_dns_infoUser.c -sheader /dev/null -server /dev/null ../dnsinfo/shared_dns_info.defs
    mig -arch x86_64 -header derived/config.h          -user derived/configUser.c          -sheader /dev/null -server /dev/null config.defs
    mig -arch x86_64 -header derived/helper.h          -user derived/helperUser.c          -sheader /dev/null -server /dev/null helper/helper.defs
    mig -arch x86_64 -header derived/pppcontroller.h   -user derived/pppcontrollerUser.c   -sheader /dev/null -server /dev/null pppcontroller.defs

    $CC -I. -Ihelper -Iderived -F. -c SCSchemaDefinitions.c -o SCSchemaDefinitions.o
    $CC -I. -Ihelper -Iderived -F. -c SCD.c -o SCD.o
    $CC -I. -Ihelper -Iderived -F. -c SCDKeys.c -o SCDKeys.o
    $CC -I. -Ihelper -Iderived -F. -c SCDPrivate.c -o SCDPrivate.o
    $CC -I. -Ihelper -Iderived -F. -c SCDPlugin.c -o SCDPlugin.o
    $CC -I. -Ihelper -Iderived -F. -c CaptiveNetwork.c -o CaptiveNetwork.o
    $CC -I. -Ihelper -Iderived -F. -c SCDOpen.c -o SCDOpen.o
    $CC -I. -Ihelper -Iderived -F. -c SCDList.c -o SCDList.o
    $CC -I. -Ihelper -Iderived -F. -c SCDAdd.c -o SCDAdd.o
    $CC -I. -Ihelper -Iderived -F. -c SCDGet.c -o SCDGet.o
    $CC -I. -Ihelper -Iderived -F. -c SCDSet.c -o SCDSet.o
    $CC -I. -Ihelper -Iderived -F. -c SCDRemove.c -o SCDRemove.o
    $CC -I. -Ihelper -Iderived -F. -c SCDNotify.c -o SCDNotify.o
    $CC -I. -Ihelper -Iderived -F. -c SCDNotifierSetKeys.c -o SCDNotifierSetKeys.o
    $CC -I. -Ihelper -Iderived -F. -c SCDNotifierAdd.c -o SCDNotifierAdd.o
    $CC -I. -Ihelper -Iderived -F. -c SCDNotifierRemove.c -o SCDNotifierRemove.o
    $CC -I. -Ihelper -Iderived -F. -c SCDNotifierGetChanges.c -o SCDNotifierGetChanges.o
    $CC -I. -Ihelper -Iderived -F. -c SCDNotifierWait.c -o SCDNotifierWait.o
    $CC -I. -Ihelper -Iderived -F. -c SCDNotifierInformViaCallback.c -o SCDNotifierInformViaCallback.o
    $CC -I. -Ihelper -Iderived -F. -c SCDNotifierInformViaFD.c -o SCDNotifierInformViaFD.o
    $CC -I. -Ihelper -Iderived -F. -c SCDNotifierInformViaSignal.c -o SCDNotifierInformViaSignal.o
    $CC -I. -Ihelper -Iderived -F. -c SCDNotifierCancel.c -o SCDNotifierCancel.o
    $CC -I. -Ihelper -Iderived -F. -c SCDSnapshot.c -o SCDSnapshot.o
    $CC -I. -Ihelper -Iderived -F. -c SCP.c -o SCP.o
    $CC -I. -Ihelper -Iderived -F. -c SCPOpen.c -o SCPOpen.o
    $CC -I. -Ihelper -Iderived -F. -c SCPLock.c -o SCPLock.o
    $CC -I. -Ihelper -Iderived -F. -c SCPUnlock.c -o SCPUnlock.o
    $CC -I. -Ihelper -Iderived -F. -c SCPList.c -o SCPList.o
    $CC -I. -Ihelper -Iderived -F. -c SCPGet.c -o SCPGet.o
    $CC -I. -Ihelper -Iderived -F. -c SCPAdd.c -o SCPAdd.o
    $CC -I. -Ihelper -Iderived -F. -c SCPSet.c -o SCPSet.o
    $CC -I. -Ihelper -Iderived -F. -c SCPRemove.c -o SCPRemove.o
    $CC -I. -Ihelper -Iderived -F. -c SCPCommit.c -o SCPCommit.o
    $CC -I. -Ihelper -Iderived -F. -c SCPApply.c -o SCPApply.o
    $CC -I. -Ihelper -Iderived -F. -c SCPPath.c -o SCPPath.o
    $CC -I. -Ihelper -Iderived -F. -c SCDConsoleUser.c -o SCDConsoleUser.o
    $CC -I. -Ihelper -Iderived -F. -c SCDHostName.c -o SCDHostName.o
    $CC -I. -Ihelper -Iderived -F. -c SCLocation.c -o SCLocation.o
    $CC -I. -Ihelper -Iderived -F. -c SCNetwork.c -o SCNetwork.o
    $CC -I. -Ihelper -Iderived -F. -c derived/pppcontrollerUser.c -o pppcontrollerUser.o
    $CC -I. -Ihelper -Iderived -F. -c SCNetworkConnection.c -o SCNetworkConnection.o
    $CC -I. -Ihelper -Iderived -F. -c SCNetworkConnectionPrivate.c -o SCNetworkConnectionPrivate.o
    $CC -I. -Ihelper -Iderived -I../dnsinfo -F. -c SCNetworkReachability.c -o SCNetworkReachability.o
    $CC -I. -Ihelper -Iderived -F. -c SCProxies.c -o SCProxies.o
    $CC -I. -Ihelper -Iderived -F. -c DHCP.c -o DHCP.o
    $CC -I. -Ihelper -Iderived -F. -c moh.c -o moh.o
    $CC -I. -Ihelper -Iderived -F. -c DeviceOnHold.c -o DeviceOnHold.o
    $CC -I. -Ihelper -Iderived -I $HACK -F. -c LinkConfiguration.c -o LinkConfiguration.o
    $CC -I. -Ihelper -Iderived -F. -c dy_framework.c -o dy_framework.o
    $CC -I. -Ihelper -Iderived -I $HACK -F. -c VLANConfiguration.c -o VLANConfiguration.o
    $CC -I. -Ihelper -Iderived -F. -c derived/configUser.c -o configUser.o
    $CC -I. -Ihelper -Iderived -F. -c SCPreferencesPathKey.c -o SCPreferencesPathKey.o
    $CC -I. -Ihelper -Iderived -I../dnsinfo -F. -c derived/shared_dns_infoUser.c -o shared_dns_infoUser.o
    $CC -I. -Ihelper -Iderived -F. -c SCNetworkConfigurationInternal.c -o SCNetworkConfigurationInternal.o
    $CC -I. -Ihelper -Iderived -F. -c SCNetworkInterface.c -o SCNetworkInterface.o
    $CC -I. -Ihelper -Iderived -F. -c SCNetworkProtocol.c -o SCNetworkProtocol.o
    $CC -I. -Ihelper -Iderived -F. -c SCNetworkService.c -o SCNetworkService.o
    $CC -I. -Ihelper -Iderived -F. -c SCNetworkSet.c -o SCNetworkSet.o
    $CC -I. -Ihelper -Iderived -I $HACK -F. -c BondConfiguration.c -o BondConfiguration.o
    $CC -I. -Ihelper -Iderived -I $HACK -F. -c BridgeConfiguration.c -o BridgeConfiguration.o
    $CC -I. -Ihelper -Iderived -F. -c helper/SCHelper_client.c -o SCHelper_client.o
    $CC -I. -Ihelper -Iderived -F. -c SCPreferencesKeychainPrivate.c -o SCPreferencesKeychainPrivate.o
    $CC -I. -Ihelper -Iderived -F. -c SCNetworkSignature.c -o SCNetworkSignature.o
    $CC -I. -Ihelper -Iderived -F. -c VPNPrivate.c -o VPNPrivate.o
    $CC -I. -Ihelper -Iderived -F. -c VPNConfiguration.c -o VPNConfiguration.o
    $CC -I. -Ihelper -Iderived -F. -c VPNTunnel.c -o VPNTunnel.o
    $CC -I. -Ihelper -Iderived -F. -c derived/helperUser.c -o helperUser.o
    $CC -I. -Ihelper -Iderived -F. -c reachability/SCNetworkReachabilityServer_client.c -o SCNetworkReachabilityServer_client.o
    $CC -I. -Ihelper -Iderived -F. -c reachability/rb.c -o rb.o
    $CC -I. -Ihelper -Iderived -F. -c derived/SystemConfiguration_vers.c -o SystemConfiguration_vers.o

    $CC -dynamiclib *.o -install_name $out/Library/Frameworks/SystemConfiguration.framework/SystemConfiguration -dead_strip -framework CoreFoundation -single_module -o SystemConfiguration.framework/SystemConfiguration

    popd >/dev/null
  '';

  installPhase = ''
    mkdir -p $out/include
    cp dnsinfo/*.h $out/include/
  '' + lib.optionalString (!headersOnly) ''
    mkdir -p $out/Library/Frameworks/
    mv SystemConfiguration.fproj/SystemConfiguration.framework $out/Library/Frameworks
  '';
}
