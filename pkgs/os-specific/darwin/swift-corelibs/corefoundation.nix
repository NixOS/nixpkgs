{ lib, stdenv, fetchFromGitHub, fetchurl, makeSetupHook, ninja, python3, curl, libxml2, objc4, ICU }:

let
  # 10.12 adds a new sysdir.h that our version of CF in the main derivation depends on, but
  # isn't available publicly, so instead we grab an older version of the same file that did
  # not use sysdir.h, but provided the same functionality. Luckily it's simple :) hack hack
  sysdir-free-system-directories = fetchurl {
    url    = "https://raw.githubusercontent.com/apple/swift-corelibs-foundation/9a5d8420f7793e63a8d5ec1ede516c4ebec939f0/CoreFoundation/Base.subproj/CFSystemDirectories.c";
    sha256 = "0krfyghj4f096arvvpf884ra5czqlmbrgf8yyc0b3avqmb613pcc";
  };
in

stdenv.mkDerivation {
  pname = "swift-corefoundation";
  version = "unstable-2018-09-14";

  src = fetchFromGitHub {
    owner  = "apple";
    repo   = "swift-corelibs-foundation";
    rev    = "71aaba20e1450a82c516af1342fe23268e15de0a";
    sha256 = "17kpql0f27xxz4jjw84vpas5f5sn4vdqwv10g151rc3rswbwln1z";
  };

  nativeBuildInputs = [ ninja python3 ];
  buildInputs = [ curl libxml2 objc4 ICU ];

  patches = [ ./0001-Add-missing-TARGET_OS_-defines.patch ];

  postPatch = ''
    cd CoreFoundation

    cp ${sysdir-free-system-directories} Base.subproj/CFSystemDirectories.c

    # In order, since I can't comment individual lines:
    # 1. Disable dispatch support for now
    # 2. For the linker too
    # 3. Use the legit CoreFoundation.h, not the one telling you not to use it because of Swift
    substituteInPlace build.py \
      --replace "cf.CFLAGS += '-DDEPLOYMENT" '#' \
      --replace "cf.LDFLAGS += '-ldispatch" '#'

    # Fix sandbox impurities.
    substituteInPlace ../lib/script.py \
      --replace '/bin/cp' cp
    patchShebangs --build ../configure

    # Includes xpc for some initialization routine that they don't define anyway, so no harm here
    substituteInPlace PlugIn.subproj/CFBundlePriv.h \
      --replace '#if (TARGET_OS_MAC' '#if (0'

    # Why do we define __GNU__? Is that normal?
    substituteInPlace Base.subproj/CFAsmMacros.h \
      --replace '#if defined(__GNU__) ||' '#if 0 &&'

    # The MIN macro doesn't seem to be defined sensibly for us. Not sure if our stdenv or their bug
    substituteInPlace Base.subproj/CoreFoundation_Prefix.h \
      --replace '#if DEPLOYMENT_TARGET_WINDOWS || DEPLOYMENT_TARGET_LINUX' '#if 1'

    # Somehow our ICU doesn't have this, probably because it's too old (we'll update it soon when we update the rest of the SDK)
    substituteInPlace Locale.subproj/CFLocale.c \
      --replace '#if U_ICU_VERSION_MAJOR_NUM' '#if 0 //'
  '';

  BUILD_DIR = "./Build";
  CFLAGS = "-DINCLUDE_OBJC -I${libxml2.dev}/include/libxml2"; # They seem to assume we include objc in some places and not in others, make a PR; also not sure why but libxml2 include path isn't getting picked up from buildInputs

  # I'm guessing at the version here. https://github.com/apple/swift-corelibs-foundation/commit/df3ec55fe6c162d590a7653d89ad669c2b9716b1 imported "high sierra"
  # and this version is a version from there. No idea how accurate it is.
  LDFLAGS = "-current_version 1454.90.0 -compatibility_version 150.0.0 -init ___CFInitialize";

  configurePhase = ''
    ../configure release --sysroot UNUSED
  '';

  enableParallelBuilding = true;

  buildPhase = ''
    runHook preBuild

    ninja -j $NIX_BUILD_CORES

    runHook postBuild
  '';

  # TODO: their build system sorta kinda can do this, but it doesn't seem to work right now
  # Also, this includes a bunch of private headers in the framework, which is not what we want
  installPhase = ''
    base="$out/Library/Frameworks/CoreFoundation.framework"
    mkdir -p $base/Versions/A/{Headers,PrivateHeaders,Modules}

    cp ./Build/CoreFoundation/libCoreFoundation.dylib $base/Versions/A/CoreFoundation

    # Note that this could easily live in the ldflags above as `-install_name @rpath/...` but
    # https://github.com/NixOS/nixpkgs/issues/46434 thwarts that, so for now I'm hacking it up
    # after the fact.
    install_name_tool -id '@rpath/CoreFoundation.framework/Versions/A/CoreFoundation' $base/Versions/A/CoreFoundation

    cp ./Build/CoreFoundation/usr/include/CoreFoundation/*.h $base/Versions/A/Headers
    cp ./Build/CoreFoundation/usr/include/CoreFoundation/module.modulemap $base/Versions/A/Modules

    ln -s A $base/Versions/Current

    for i in CoreFoundation Headers Modules; do
      ln -s Versions/Current/$i $base/$i
    done
  '';

    darwinEnvHook = makeSetupHook { name = "darwin-env-hook"; } ./pure-corefoundation-hook.sh;
}
