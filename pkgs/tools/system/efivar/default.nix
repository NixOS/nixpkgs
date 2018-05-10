{ stdenv, fetchFromGitHub, pkgconfig, popt }:

stdenv.mkDerivation rec {
  name = "efivar-${version}";
  version = "35";

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = "efivar";
    rev = version;
    sha256 = "0hc7l5z0hw5472bm6p4d9n24bbggv9lgw7px1hqrdkfjghqfnlxh";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ popt ];

  makeFlags = [
    "prefix=$(out)"
    "libdir=$(out)/lib"
  ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Tools and library to manipulate EFI variables";
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
