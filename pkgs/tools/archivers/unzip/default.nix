{ lib, stdenv, fetchurl
, bzip2
, enableNLS ? false, libnatspec
}:

stdenv.mkDerivation rec {
  pname = "unzip";
  version = "6.0";

  src = fetchurl {
    url = "mirror://sourceforge/infozip/unzip${lib.replaceStrings ["."] [""] version}.tar.gz";
    sha256 = "0dxx11knh3nk95p2gg2ak777dd11pr7jx5das2g49l262scrcv83";
  };

  hardeningDisable = [ "format" ];

  patchFlags = [ "-p1" "-F3" ];

  patches = [
    ./CVE-2014-8139.diff
    ./CVE-2014-8140.diff
    ./CVE-2014-8141.diff
    ./CVE-2014-9636.diff
    ./CVE-2015-7696.diff
    ./CVE-2015-7697.diff
    ./CVE-2014-9913.patch
    ./CVE-2016-9844.patch
    ./CVE-2018-18384.patch
    ./dont-hardcode-cc.patch
    (fetchurl {
      url = "https://github.com/madler/unzip/commit/41beb477c5744bc396fa1162ee0c14218ec12213.patch";
      name = "CVE-2019-13232-1.patch";
      sha256 = "04jzd6chg9fw4l5zadkfsrfm5llrd7vhd1dgdjjd29nrvkrjyn14";
    })
    (fetchurl {
      url = "https://github.com/madler/unzip/commit/47b3ceae397d21bf822bc2ac73052a4b1daf8e1c.patch";
      name = "CVE-2019-13232-2.patch";
      sha256 = "0iy2wcjyvzwrjk02iszwcpg85fkjxs1bvb9isvdiywszav4yjs32";
    })
    (fetchurl {
      url = "https://github.com/madler/unzip/commit/6d351831be705cc26d897db44f878a978f4138fc.patch";
      name = "CVE-2019-13232-3.patch";
      sha256 = "1jvs7dkdqs97qnsqc6hk088alhv8j4c638k65dbib9chh40jd7pf";
    })
  ] ++ lib.optional enableNLS
    (fetchurl {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/app-arch/unzip/files/unzip-6.0-natspec.patch?id=56bd759df1d0c750a065b8c845e93d5dfa6b549d";
      name = "unzip-6.0-natspec.patch";
      sha256 = "67ab260ae6adf8e7c5eda2d1d7846929b43562943ec4aff629bd7018954058b1";
    });

  nativeBuildInputs = [ bzip2 ];
  buildInputs = [ bzip2 ] ++ lib.optional enableNLS libnatspec;

  makefile = "unix/Makefile";

  NIX_LDFLAGS = "-lbz2" + lib.optionalString enableNLS " -lnatspec";

  buildFlags = [
    "generic"
    "D_USE_BZ2=-DUSE_BZIP2"
    "L_BZ2=-lbz2"
  ];

  preConfigure = ''
    sed -i -e 's@CF="-O3 -Wall -I. -DASM_CRC $(LOC)"@CF="-O3 -Wall -I. -DASM_CRC -DLARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 $(LOC)"@' unix/Makefile
  '';

  installFlags = [
    "prefix=${placeholder "out"}"
  ];

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "http://www.info-zip.org";
    description = "An extraction utility for archives compressed in .zip format";
    license = lib.licenses.free; # http://www.info-zip.org/license.html
    platforms = lib.platforms.all;
  };
}
