{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config
, docopt_cpp, file, gumbo, mustache-hpp, zimlib, zlib
, gtest
}:

stdenv.mkDerivation rec {
  pname = "zim-tools";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "openzim";
    repo = "zim-tools";
    rev = version;
    sha256 = "sha256-dFZd+vr/PnC7WKTFitwBe1zd/1TUnCznI/eS+Q0ZZPg=";
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
