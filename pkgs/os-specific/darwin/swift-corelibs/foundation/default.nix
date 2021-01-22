{ lib, stdenv, fetchFromGitHub, fetchurl, fetchpatch, ninja, cmake, curl, libxml2, ICU }:

let
  # 10.12 adds a new sysdir.h that our version of CoreFoundation in the main derivation depends on, but
  # isn't available publicly, so instead we grab an older version of the same file that did
  # not use sysdir.h, but provided the same functionality. Luckily it's simple :) hack hack
  sysdir-free-system-directories = fetchurl {
    url    = "https://raw.githubusercontent.com/apple/swift-corelibs-foundation/9a5d8420f7793e63a8d5ec1ede516c4ebec939f0/CoreFoundation/Base.subproj/CFSystemDirectories.c";
    sha256 = "0krfyghj4f096arvvpf884ra5czqlmbrgf8yyc0b3avqmb613pcc";
  };
in

stdenv.mkDerivation rec {
  pname   = "CoreFoundation";
  version = "swift-5.3.2"; # not the real version, APPLE refuse to give one. https://github.com/apple/swift-corelibs-foundation/commit/df3ec55fe6c162d590a7653d89ad669c2b9716b1#commitcomment-30442619

  src = fetchFromGitHub {
    owner  = "apple";
    repo   = "swift-corelibs-foundation";
    rev    = "${version}-RELEASE";
    sha256 = "1fd0djza84rdh4jw7kw0kgm22r7jmga6zx1drzpymvpqyscxqsdq";
  };

  # TODO: patches are in upstream. Check if they can be dropped in next update.
  patches = [
    # fix unwanted including objc
    (fetchpatch {
      url = "https://github.com/apple/swift-corelibs-foundation/pull/2976/commits/1e92742e04cb73a7d1572245be3a5c31cbe81e14.patch";
      sha256 = "0hqg8jikdfqzx52lnz3y17cd0rxby1jik78dgfggv3lqx4hfh3dz";
    })
    # fix extra symbol __kCFAllocatorTypeID_CONST
    (fetchpatch {
      url = "https://github.com/apple/swift-corelibs-foundation/commit/5a022ef99f37f78eb2f758fa47e2d751469151f9.patch";
      sha256 = "1wyaxzdnzf11p8h28nx426ri8m179pmgz3ljp9y97sc3xajw1rla";
    })
  ];

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ curl libxml2 ICU ];

  sourceRoot = "source/CoreFoundation";
  patchFlags = "-p2";

  postPatch = ''
    cp ${sysdir-free-system-directories} Base.subproj/CFSystemDirectories.c

    # Includes xpc for some initialization routine that they don't define anyway, so no harm here
    substituteInPlace PlugIn.subproj/CFBundlePriv.h \
      --replace '#if TARGET_OS_OSX || TARGET_OS_IPHONE' '#if 0'

    # Somehow our ICU doesn't have this, probably because it's too old (we'll update it soon when we update the rest of the SDK)
    substituteInPlace Locale.subproj/CFLocale.c \
      --replace '#if U_ICU_VERSION_MAJOR_NUM' '#if 0 //'
  '';

  # DSTROOT   = "$out";
  # PREFIX    = "";
  # BUILD_DIR = "./Build";

  CFLAGS = [
    # these are defined in ForSwiftFoundationOnly.h but used outside Swift. https://bugs.swift.org/browse/SR-14077
    "-D_CFAllocatorHintZeroWhenAllocating=1"
    "-D_CFThreadRef=pthread_t"
    "-D_CFThreadSpecificKey=pthread_key_t"

    # A required string but never defined, not even in Apple's build script. https://bugs.swift.org/browse/SR-14078
    ''-DOS_LOG_SUBSYSTEM_RUNTIME_ISSUES=\"os_log_subsystem_runtime_issues\"''
  ];

  # See comment beside ${version}. No idea how accurate it is.
  # LDFLAGS = "-current_version 1454.90.0 -compatibility_version 150.0.0 -init ___CFInitialize";

  enableParallelBuilding = false;

  # FIXME: It seems fixed. Trun true if not, otherwise delete below next update.
  # FIXME: Workaround for intermittent build failures of CFRuntime.c.
  # Based on testing this issue seems to only occur with clang_7, so
  # please remove this when updating the default llvm versions to 8 or
  # later.
  buildPhase = lib.optionalString false ''
    for i in {1..512}; do
        if ninja -j $NIX_BUILD_CORES; then
            break
        fi

        echo >&2
        echo "[$i/512] retrying build, workaround for #66811" >&2
        echo "  With clang_7 the build of CFRuntime.c fails intermittently." >&2
        echo "  See https://github.com/NixOS/nixpkgs/issues/66811 for more details." >&2
        echo >&2
        continue
    done
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

  meta = with lib; {
    description = "CoreFoundation from Apple Swift Foundation framework";
    # In fact it could build on linux and windows too, but I doubt if anyone wants it.
    # Maybe move out of os-specific/darwin if other platforms realy needs it.
    platforms   = platforms.darwin;
    license     = licenses.apsl20;
  };
}
