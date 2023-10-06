{ stdenv, fetchurl, popt, ncurses, python3, readline, lib }:

stdenv.mkDerivation rec {
  pname = "OpenIPMI";
  version = "2.0.34";

  src = fetchurl {
    url = "mirror://sourceforge/openipmi/OpenIPMI-${version}.tar.gz";
    sha256 = "sha256-kyJ+Q8crXDvVlJMj4GaapVJ9GpcUc6OjZa8D+4KEqV8=";
  };

  buildInputs = [ ncurses popt python3 readline ];

  outputs = [ "out" "lib" "dev" "man" ];

  meta = with lib; {
    homepage = "https://openipmi.sourceforge.io/";
    description = "A user-level library that provides a higher-level abstraction of IPMI and generic services";
    license = with licenses; [ gpl2Only lgpl2Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ arezvov ] ++ teams.c3d2.members;
  };
}
