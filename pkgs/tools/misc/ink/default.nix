{ lib, stdenv, fetchurl, libinklevel }:

stdenv.mkDerivation rec {
  pname = "ink";
  version = "0.5.3";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1fk0b8vic04a3i3vmq73hbk7mzbi57s8ks6ighn3mvr6m2v8yc9d";
  };

  buildInputs = [
    libinklevel
  ];

  outputs = [ "out" "man" ];

  meta = with lib; {
    description = "Command line tool for checking the ink level of your locally connected printer";
    longDescription = ''
      Ink is a command line tool for checking the ink level of your locally connected printer on a system which runs Linux or FreeBSD. Canon BJNP network printers are supported too.
    '';
    homepage = "https://ink.sourceforge.net/";
    license = licenses.gpl2Only;
    platforms = platforms.linux ++ platforms.freebsd;
    maintainers = with maintainers; [ samb96 ];
    mainProgram = "ink";
  };
}
