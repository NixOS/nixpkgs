{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libexif, popt, libintl }:

stdenv.mkDerivation rec {
  pname = "exif";
  version = "0.6.22";

  src = fetchFromGitHub {
    owner = "libexif";
    repo = pname;
    rev = "${pname}-${builtins.replaceStrings ["."] ["_"] version}-release";
    sha256 = "1xlb1gdwxm3rmw7vlrynhvjp9dkwmvw23mxisdbdmma7ah2nda3i";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libexif popt libintl ];

  meta = with lib; {
    homepage = "https://libexif.github.io";
    description = "A utility to read and manipulate EXIF data in digital photographs";
    platforms = platforms.unix;
    license = licenses.lgpl21Plus;
  };
}
