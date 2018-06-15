{ IOKit, appleDerivation, apple_sdk, libauto, libobjc, libsecurity_codesigning, sqlite, stdenv, osx_private_sdk }:
appleDerivation {
  buildInputs = [
    libauto
    libobjc
    IOKit
  ];
  propagatedBuildInputs = [
    sqlite
    apple_sdk.frameworks.PCSC
  ];
  NIX_LDFLAGS = "-framework PCSC";
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
    cp -R ${osx_private_sdk}/include/bsm lib
    cp ${osx_private_sdk}/include/utilities_dtrace.h lib
  '' + stdenv.lib.optionalString (!stdenv.cc.nativeLibc) ''
    substituteInPlace lib/vproc++.cpp --replace /usr/local/include/vproc_priv.h ${stdenv.libc}/include/vproc_priv.h
  '';
}
