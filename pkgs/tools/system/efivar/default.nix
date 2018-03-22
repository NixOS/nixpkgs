{ stdenv, fetchFromGitHub, pkgconfig, popt }:

stdenv.mkDerivation rec {
  name = "efivar-${version}";
  version = "34";

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = "efivar";
    rev = version;
    sha256 = "0ycrdaz0ijkm3xb9fnwzhwi0pdj5c6s636wj4i6lbjbrijbzn4x5";
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
