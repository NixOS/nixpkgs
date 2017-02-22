{ stdenv, fetchFromGitHub, pkgconfig, popt }:

stdenv.mkDerivation rec {
  name = "efivar-${version}";
  version = "31";

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = "efivar";
    rev = version;
    sha256 = "0dhycikylm87jmds4ii5ygwq59g4sa5sv9mzryjzgqlgppw5arli";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ popt ];

  postPatch = ''
     substituteInPlace src/Makefile --replace "-static" ""
  '';

  installFlags = [
    "libdir=$(out)/lib"
    "mandir=$(out)/share/man"
    "includedir=$(out)/include"
    "bindir=$(out)/bin"
  ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Tools and library to manipulate EFI variables";
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
