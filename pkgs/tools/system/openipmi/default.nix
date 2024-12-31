{ stdenv, fetchurl, popt, ncurses, python3, readline, lib, openssl }:

stdenv.mkDerivation rec {
  pname = "OpenIPMI";
  version = "2.0.35";

  src = fetchurl {
    url = "mirror://sourceforge/openipmi/OpenIPMI-${version}.tar.gz";
    sha256 = "sha256-sFkRT2KZ1z8E/252oIV6Crgao2Le6ZZE0layI4ckN60=";
  };

  buildInputs = [ ncurses popt python3 readline openssl ];

  outputs = [ "out" "lib" "dev" "man" ];

  meta = with lib; {
    homepage = "https://openipmi.sourceforge.io/";
    description = "User-level library that provides a higher-level abstraction of IPMI and generic services";
    license = with licenses; [ gpl2Only lgpl2Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ arezvov ] ++ teams.c3d2.members;
  };
}
