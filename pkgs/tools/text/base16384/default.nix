{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "base16384";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "fumiama";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nHr7S3UrNaR/5YGwfDUxVXqTkaT3EYzA8CaS0lWZxN0=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Encode binary files to printable utf16be";
    homepage = "https://github.com/fumiama/base16384";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.all;
  };
}
