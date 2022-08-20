{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config
, docopt_cpp, file, gumbo, mustache-hpp, zimlib, zlib
, gtest
}:

stdenv.mkDerivation rec {
  pname = "zim-tools";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "openzim";
    repo = "zim-tools";
    rev = version;
    sha256 = "sha256-xZae1o4L9AdGDqBnFDZniWNM/dLsYRcS0OLWw9+Wecs=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ docopt_cpp file gumbo mustache-hpp zimlib zlib ];

  checkInputs = [ gtest ];
  doCheck = true;

  meta = {
    description = "Various ZIM command line tools";
    homepage = "https://github.com/openzim/zim-tools";
    maintainers = with lib.maintainers; [ robbinch ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
}
