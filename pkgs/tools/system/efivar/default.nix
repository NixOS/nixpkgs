{ stdenv, fetchFromGitHub, pkgconfig, popt }:

stdenv.mkDerivation rec {
  name = "efivar-${version}";
  version = "30";

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = "efivar";
    rev = version;
    sha256 = "1pghj019qr7qpqd9rxfhsr1hm3s0w1hd5cdndpl07vhys8hy4a8a";
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
