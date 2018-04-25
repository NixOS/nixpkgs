{ stdenv, lib, fetchgit, fetchzip, fetchpatch
, libevent, ninja, python, darwin }:

let
  depsGit = {
    "tools/gn" = fetchgit {
      url = "https://chromium.googlesource.com/chromium/src/tools/gn";
      rev = "0fa417a0d2d8484e9a5a636e3301da322f586601";
      sha256 = "0pigcl14yc4aak6q1ghfjxdz2ah4fg4m2r5y3asw2rz6mpr5y9z0";
    };
    "base" = fetchgit {
      url = "https://chromium.googlesource.com/chromium/src/base";
      rev = "ab1d7c3b92ce9c9bc756bdefb8338360d1a33a1e";
      sha256 = "15wis6qg9ka62k6v1vamg0bp3v5vkpapg485jsn4bbfcaqp6di0f";
    };
    "build" = fetchgit {
      url = "https://chromium.googlesource.com/chromium/src/build";
      rev = "8d44c08a4c9997695db8098198bdd5026bc7a6f9";
      sha256 = "19sajgf55xfmvnwvy2ss7g6pyljp751cfsws30w415m6m00lmpxl";
    };
    "config" = fetchgit {
      url = "https://chromium.googlesource.com/chromium/src/build/config";
      rev = "14116c0cdcb9e28995ca8bb384a12e5c9dbd1dbb";
      sha256 = "04nif0lm4wcy05b7xhal023874s4r0iq067q57cgwdm72i2gml40";
    };
    "testing/gtest" = fetchgit {
      url = "https://chromium.googlesource.com/chromium/testing/gtest";
      rev = "585ec31ea716f08233a815e680fc0d4699843938";
      sha256 = "0csn1cza66851nmxxiw42smsm3422mx67vcyykwn0a71lcjng6rc";
    };
    "third_party/apple_apsl" = fetchzip {
      url = "https://chromium.googlesource.com/chromium/src/third_party/+archive/8e6ccb8c74db6dfa15dd21401ace3ac96c054cf7/apple_apsl.tar.gz";
      sha256 = "1vgcg741lwz84kdy0qc5wn9dxx3j9zh6a9d185fpygdsipwikqv8";
      stripRoot = false;
    };
    "buildtools/third_party/libc++/trunk" = fetchgit {
      url = "https://chromium.googlesource.com/chromium/llvm-project/libcxx";
      rev = "ece1de8658d749e19c12cacd4458cc330eca94e3";
      sha256 = "1nlyvfkzhchwv9b18bh82jcamqv3acj26ah9ajs31f2dql05amhg";
    };
    "buildtools/third_party/libc++abi/trunk" = fetchgit {
      url = "https://chromium.googlesource.com/chromium/llvm-project/libcxxabi";
      rev = "52c7a3760aef1df328a9bc957f686410872f0dc0";
      sha256 = "1aam539j01381q27b7xhij18pz3h0lhw08hglvqq4hgvlqx5cn2s";
    };
  };

in stdenv.mkDerivation {
  name = "gn";
  version = "20180423";
  sourceRoot = ".";

  unpackPhase = ''
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (n: v: ''
        mkdir -p $sourceRoot/${n}
        if [ -d ${v} ]; then
          cp -r ${v}/* $sourceRoot/${n}
        else
          mkdir -p $sourceRoot/${n}
          pushd $sourceRoot/${n}
          unpackFile ${v}
          popd
        fi
      '') depsGit)}

    chmod u+w -R $sourceRoot
  '';

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/Eloston/ungoogled-chromium/master/resources/patches/ungoogled-chromium/macos/fix-gn-bootstrap.patch";
      sha256 = "1h8jgxznm7zrxlzb4wcfx4zx4lyvfrmpd0r7cd7h0s23wn8ibb3a";
    })
  ];

  postPatch = ''
    # Disable libevent bootstrapping (we will provide it).
    sed -i -e '/static_libraries.*libevent/,/^ *\]\?[})]$/d' \
      tools/gn/bootstrap/bootstrap.py

    # FIXME Needed with old Apple SDKs
    substituteInPlace base/mac/foundation_util.mm \
      --replace "NSArray<NSString*>*" "NSArray*"
    substituteInPlace base/mac/sdk_forward_declarations.h \
      --replace "NSDictionary<VNImageOption, id>*" "NSDictionary*" \
      --replace "NSArray<VNRequest*>*" "NSArray*" \
      --replace "typedef NSString* VNImageOption NS_STRING_ENUM" "typedef NSString* VNImageOption"

    # Patch shebangs (for sandbox build)
    patchShebangs build
  '';

  # FIXME again this shouldn't be necessary but I can't figure out a better way
  NIX_CFLAGS_COMPILE = "-DMAC_OS_X_VERSION_MAX_ALLOWED=MAC_OS_X_VERSION_10_10 -DMAC_OS_X_VERSION_MIN_REQUIRED=MAC_OS_X_VERSION_10_10";

  NIX_LDFLAGS = "-levent";

  nativeBuildInputs = [ ninja python ];
  buildInputs = [ libevent ]

  # FIXME These dependencies shouldn't be needed but can't find a way
  # around it. Chromium pulls this in while bootstrapping GN.
  ++ lib.optionals stdenv.isDarwin (with darwin; with apple_sdk.frameworks; [
    libobjc
    cctools

    # frameworks
    ApplicationServices
    Foundation
    AppKit
    ImageCaptureCore
    CoreBluetooth
    IOBluetooth
    CoreWLAN
    Quartz
    Cocoa
  ]);

  buildPhase = ''
    python tools/gn/bootstrap/bootstrap.py -s
  '';

  installPhase = ''
    install -vD out/Release/gn "$out/bin/gn"
  '';

  meta = with lib; {
    description = "A meta-build system that generates NinjaBuild files";
    homepage = https://chromium.googlesource.com/chromium/src/tools/gn;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ stesie matthewbauer ];
  };
}
