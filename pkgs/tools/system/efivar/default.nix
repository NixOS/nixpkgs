{ stdenv, fetchFromGitHub, pkgconfig, popt }:

stdenv.mkDerivation rec {
  name = "efivar-${version}";
  version = "27";

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = "efivar";
    rev = version;
    sha256 = "1vz3hzs9k7bjg2r5bsw1irnfq77lmq9819sg9a7w6w528bvzr4lx";
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
