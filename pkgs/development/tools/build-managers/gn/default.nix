{ stdenv, lib, fetchgit, fetchurl, libevent, libtool, ninja, python
, AppKit, ApplicationServices, Cocoa, CoreBluetooth, Foundation, ImageCaptureCore }:

let
  depsGit = {
    "tools/gn" = fetchgit {
      url = "https://chromium.googlesource.com/chromium/src/tools/gn";
      rev = "858366e6b3803ff067862a9b994776fc11124ba2";
      sha256 = "0nylfi9jnp8f8i1vr7jxdskvjr7hi1g9hg7qxxqcy4bdrfr2npra";
    };
    "base" = fetchgit {
      url = "https://chromium.googlesource.com/chromium/src/base";
      rev = "d56f52a20c2ca2ab28579677d2ea5483401bd47e";
      sha256 = "0b29bmi3qfnvxwcljzbzi6im49nd7j6pf9zb5c53zb9pilwpsrqq";
    };
    "build" = fetchgit {
      url = "https://chromium.googlesource.com/chromium/src/build";
      rev = "e934a19ae908081fba13769924e4ea45a7a451ce";
      sha256 = "0jhy418vaiin7djg9zvk83f8zhasigki4442x5j7gkmgmgmyc4am";
    };
    "config" = fetchgit {
      url = "https://chromium.googlesource.com/chromium/src/build/config";
      rev = "df16c6a2c070704b0a25efe46ee9af16de1e65b3";
      sha256 = "1x18syzz1scwhd8lf448hy5lnfpq118l403x9qmwm0np318w09wg";
    };
    "testing/gtest" = fetchgit {
      url = "https://chromium.googlesource.com/chromium/testing/gtest";
      rev = "585ec31ea716f08233a815e680fc0d4699843938";
      sha256 = "0csn1cza66851nmxxiw42smsm3422mx67vcyykwn0a71lcjng6rc";
    };
  };

  appleApsl = fetchurl {
    url = "https://chromium.googlesource.com/chromium/src/third_party/+archive/7b93eb6514e15b92eb8d8b1767b92612c12c3364/apple_apsl.tar.gz";
    sha256 = "00s9nfgz30877h48jd1831l1fp05i33cpya7264scm9firw3r0id";
  };

in
  stdenv.mkDerivation rec {
    name = "gn";
    version = "0.0.0.20171013";
    sourceRoot = ".";

    unpackPhase = ''
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (n: v: ''
          mkdir -p $sourceRoot/${n}
          cp -r ${v}/* $sourceRoot/${n}
        '') depsGit)}
    '' + stdenv.lib.strings.optionalString stdenv.isDarwin ''
      mkdir -p third_party/apple_apsl
      tar -C third_party/apple_apsl -xf ${appleApsl}
    '';

    prePatch = ''
      chmod u+w -R .
    '';

    patches = stdenv.lib.optionals stdenv.isDarwin [
      # Remove NSPressureConfiguration stuff, which is only available on MacOS 10.11+ and not part
      # of the platform libraries in nixpkgs
      ./NSPressureConfiguration.patch

      # also just remove GetModelIdentifier stuff from base library, which isn't used by GN itself
      # yet cannot be linked because of old IOKit
      ./RemoveGetModelIdentifier.patch

      # fix bootstrap, compile in some files listed in BUILD.gn, yet missing from bootstrap script
      ./bootstrap.patch
    ];

    postPatch = ''
      # Patch shebands (for sandbox build)
      patchShebangs build

      # Patch out Chromium-bundled libevent
      sed -i -e '/static_libraries.*libevent/,/^ *\]\?[})]$/d' \
          tools/gn/bootstrap/bootstrap.py
    '';

    NIX_LDFLAGS = "-levent";

    nativeBuildInputs = [ ninja python ] ++ stdenv.lib.optional stdenv.isDarwin [
      libtool AppKit ApplicationServices Cocoa CoreBluetooth Foundation ImageCaptureCore
    ];
    buildInputs = [ libevent ];

    buildPhase = ''
      python tools/gn/bootstrap/bootstrap.py -s
    '';

    installPhase = ''
      install -vD out/Release/gn "$out/bin/gn"
    '';

    meta = with stdenv.lib; {
      description = "A meta-build system that generates NinjaBuild files";
      homepage = https://chromium.googlesource.com/chromium/src/tools/gn;
      license = licenses.bsd3;
      platforms = platforms.linux ++ platforms.darwin;
      maintainers = [ maintainers.stesie ];
    };
  }
