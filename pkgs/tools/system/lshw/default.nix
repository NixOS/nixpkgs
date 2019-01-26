{ stdenv, lib, fetchurl, fetchpatch
, withGUI ? false, gtk2, pkgconfig, sqlite # compile GUI
}:

let numVersion = "02.18"; # :(
in
stdenv.mkDerivation rec {
  name = "lshw-${numVersion}b";
  version = "${numVersion}";

  src = fetchurl {
    url = "https://ezix.org/software/files/lshw-B.${version}.tar.gz";
    sha256 = "0brwra4jld0d53d7jsgca415ljglmmx1l2iazpj4ndilr48yy8mf";
  };

  patches = [ (fetchpatch {
    # fix crash in scan_dmi_sysfs() when run as non-root
    url = "https://github.com/lyonel/lshw/commit/fbdc6ab15f7eea0ddcd63da355356ef156dd0d96.patch";
    sha256 = "147wyr5m185f8swsmb4q1ahs9r1rycapbpa2548aqbv298bbish3";
  })];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = lib.optionals withGUI [ gtk2 sqlite ];

  # Fix version info.
  preConfigure = ''
    sed -e "s/return \"unknown\"/return \"${version}\"/" \
        -i src/core/version.cc
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  buildFlags = [ "all" ] ++ lib.optional withGUI "gui";

  installTargets = [ "install" ] ++ lib.optional withGUI "install-gui";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://ezix.org/project/wiki/HardwareLiSter;
    description = "Provide detailed information on the hardware configuration of the machine";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom jgeerds ];
    platforms = platforms.linux;
  };
}
