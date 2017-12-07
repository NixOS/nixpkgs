{ stdenv, lib, fetchgit, fetchurl, libevent, ninja, python }:

let
  depsGit = {
    "tools/gn" = fetchgit {
      url = "https://chromium.googlesource.com/chromium/src/tools/gn";
      rev = "d0c518db129975ce88ff1de26c857873b0619c4b";
      sha256 = "0l15vzmjyx6bwlz1qhn3fy7yx3qzzxr3drnkj3l0p0fmyxza52vx";
    };
    "base" = fetchgit {
      url = "https://chromium.googlesource.com/chromium/src/base";
      rev = "bc6e3ce8ca01b894751e1f7b22b561e3ae2e7f17";
      sha256 = "1yl49v6nxbrfms52xf7fiwh7d4301m2aj744pa3hzzh989c5j6g5";
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

in
  stdenv.mkDerivation rec {
    name = "gn";
    version = "0.0.0.20170629";
    sourceRoot = ".";

    unpackPhase = ''
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (n: v: ''
          mkdir -p $sourceRoot/${n}
          cp -r ${v}/* $sourceRoot/${n}
        '') depsGit)}
    '';

    postPatch = ''
      # Patch shebands (for sandbox build)
      chmod u+w -R build
      patchShebangs build

      # Patch out Chromium-bundled libevent
      chmod u+w tools/gn/bootstrap tools/gn/bootstrap/bootstrap.py
      sed -i -e '/static_libraries.*libevent/,/^ *\]\?[})]$/d' \
          tools/gn/bootstrap/bootstrap.py
    '';

    NIX_LDFLAGS = "-levent";

    nativeBuildInputs = [ ninja python ];
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
      platforms = platforms.linux;
      maintainers = [ maintainers.stesie ];
    };
  }
