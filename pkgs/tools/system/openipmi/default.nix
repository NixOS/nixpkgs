{ stdenv, fetchurl, popt, ncurses, python39, readline, lib }:

stdenv.mkDerivation rec {
  pname = "OpenIPMI";
  version = "2.0.32";

  src = fetchurl {
    url = "mirror://sourceforge/openipmi/OpenIPMI-${version}.tar.gz";
    sha256 = "sha256-9tD9TAp0sF+AkHIp0LJw9UyiMpS8wRl5+LjRJ2Z4aUU=";
  };

  buildInputs = [ ncurses popt python39 readline ];

  outputs = [ "out" "lib" "dev" "man" ];

  meta = with lib; {
    homepage = "https://openipmi.sourceforge.io/";
    description = "A user-level library that provides a higher-level abstraction of IPMI and generic services";
    license = with licenses; [ gpl2Only lgpl2Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ arezvov ] ++ teams.c3d2.members;
  };
}
