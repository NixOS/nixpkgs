{
  lib,
  stdenvNoCC,
  appleDerivation',
  cmake,
  ninja,
  python3,
  unifdef,
}:

appleDerivation' stdenvNoCC {
  nativeBuildInputs = [ cmake ninja python3 unifdef ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail '/usr' ""
    patchShebangs .
  '';

  cmakeFlags = [
    (lib.cmakeFeature "DSTROOT" (placeholder "out"))
  ];

  preConfigure = ''
    cmakeFlagsArray+=("-DOBJROOT=$PWD/build" "-DSRCROOT=$PWD")
  '';

  postInstall = ''
    # Remove internal and private headers
    rm -rf "$out/AppleInternal" "$out/local"
    # `__ENVIRONMENT_OS_VERSION_MIN_REQUIRED__` is only defined by clang 17+, so define it for older versions.
    sed -e '/#ifndef __MAC_OS_X_VERSION_MIN_REQUIRED/{
        i#ifndef __ENVIRONMENT_OS_VERSION_MIN_REQUIRED__
        i#define __ENVIRONMENT_OS_VERSION_MIN_REQUIRED__ __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__
        i#endif
      }' \
      -i "$out/include/AvailabilityInternal.h"
  '';
}
