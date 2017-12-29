{ IOKit, appleDerivation, apple_sdk, libauto, libobjc, libsecurity_codesigning, sqlite, stdenv, osx_private_sdk }:
appleDerivation {
  buildInputs = [
    libauto
    libobjc
    IOKit
    sqlite
    apple_sdk.frameworks.PCSC
  ];
  patchPhase = ''
    substituteInPlace lib/errors.h --replace \
      '<CoreServices/../Frameworks/CarbonCore.framework/Headers/MacTypes.h>' \
      '"MacTypes.h"'
    substituteInPlace lib/debugging.cpp --replace PATH_MAX 1024
    substituteInPlace lib/superblob.h --replace 'result->at' 'result->template at'
    substituteInPlace lib/ccaudit.cpp --replace '<bsm/libbsm.h>' '"bsm/libbsm.h"'
    substituteInPlace lib/powerwatch.h --replace \
      '<IOKit/pwr_mgt/IOPMLibPrivate.h>' \
      '"${IOKit}/Library/Frameworks/IOKit.framework/Headers/pwr_mgt/IOPMLibPrivate.h"'

    cp ${osx_private_sdk}/PrivateSDK10.9.sparse.sdk/usr/include/security_utilities/utilities_dtrace.h lib
    cp -R ${osx_private_sdk}/PrivateSDK10.9.sparse.sdk/usr/local/include/bsm lib
  '' + stdenv.lib.optionalString (!stdenv.cc.nativeLibc) ''
    substituteInPlace lib/vproc++.cpp --replace /usr/local/include/vproc_priv.h ${stdenv.libc}/include/vproc_priv.h
  '';
}
