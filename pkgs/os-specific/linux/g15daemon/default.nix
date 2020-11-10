{ stdenv
, lib
, fetchFromGitHub
, fetchurl
, fetchpatch
, patchelf
, freetype
, libusb-compat-0_1
}:
let
  license = lib.licenses.gpl2;
  maintainers = with lib.maintainers; [ peterhoeg ];

  g15src = { pname, version, sha256 }: fetchurl {
    url = "mirror://sourceforge/g15tools/${pname}/${version}/${pname}-${version}.tar.bz2";
    inherit sha256;
  };

  libg15 = stdenv.mkDerivation rec {
    pname = "libg15";
    version = "1.2.7";

    src = g15src {
      inherit pname version;
      sha256 = "1mkrf622n0cmz57lj8w9q82a9dcr1lmyyxbnrghrxzb6gvifnbqk";
    };

    buildInputs = [ libusb-compat-0_1 ];

    enableParallelBuilding = true;

    meta = {
      description = "Provides low-level access to Logitech G11/G15 keyboards and Z10 speakers";
      inherit license maintainers;
    };
  };

  libg15render = stdenv.mkDerivation rec {
    pname = "libg15render";
    version = "1.2";

    src = g15src {
      inherit pname version;
      sha256 = "03yjb78j1fnr2fwklxy54sdljwi0imvp29m8kmwl9v0pdapka8yj";
    };

    buildInputs = [ libg15 ];

    enableParallelBuilding = true;

    meta = {
      description = "A small graphics library optimised for drawing on an LCD";
      inherit license maintainers;
    };
  };
in
stdenv.mkDerivation rec {
  pname = "g15daemon";
  version = "1.9.5.3";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/G15Daemon%201.9x/${version}/${pname}-${version}.tar.bz2";
    sha256 = "1613gsp5dgilwbshqxxhiyw73ksngnam7n1iw6yxdjkp9fyd2a3d";
  };

  patches = let
    patch = fname: sha256: fetchurl rec {
      url = "https://git.archlinux.org/svntogit/community.git/plain/trunk/${pname}-${version}-${fname}.patch?h=packages/${pname}";
      name = "${fname}.patch";
      inherit sha256;
    };
  in
    [
      (patch "uinput" "1misfff7a1vg0qgfk3n25y7drnm86a4gq96iflpcwr5x3lw7q0h7")
      (patch "config-write" "0jkrbqvzqrvxr14h5qi17cb4d32caq7vw9kzlz3qwpxdgxjrjvy2")
      (patch "recv-oob-answer" "1f67iqpj5hcgpakagi7gbw1xviwhy5vizs546l9bfjimx8r2d29g")
      ./pid_location.patch
    ];

  buildInputs = [ libg15 libg15render ];

  enableParallelBuilding = true;

  meta = {
    description = "A daemon that makes it possible to use the Logitech keyboard G-Buttons and draw on various Logitech LCDs";
    inherit license maintainers;
  };
}
