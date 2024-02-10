{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config
, docopt_cpp, file, gumbo, mustache-hpp, zimlib, zlib
, gtest
}:

stdenv.mkDerivation rec {
  pname = "zim-tools";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "openzim";
    repo = "zim-tools";
    rev = version;
    sha256 = "sha256-kPUw13GVYZ1GLb4b4ch64GkJZtf6PW1gae8F/cgyG90=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ docopt_cpp file gumbo mustache-hpp zimlib zlib ];

  nativeCheckInputs = [ gtest ];
  doCheck = true;

  meta = {
    description = "Various ZIM command line tools";
    homepage = "https://github.com/openzim/zim-tools";
    maintainers = with lib.maintainers; [ robbinch ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
}
