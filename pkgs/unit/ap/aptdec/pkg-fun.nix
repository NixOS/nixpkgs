{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, libpng, libsndfile
}:

stdenv.mkDerivation {
  pname = "aptdec";
  version = "unstable-2022-05-18";

  src = fetchFromGitHub {
    owner = "Xerbo";
    repo = "aptdec";
    rev = "b1cc7480732349a7c772124f984b58f4c734c91b";
    sha256 = "sha256-Fi9IkZcvqxpmHzqucpCr++37bmTtMy18P4LPznoaYIY=";
  };

  # fixes https://github.com/Xerbo/aptdec/issues/15
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "-Werror" ""
  '';

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libpng libsndfile ];

  meta = with lib; {
    description = "NOAA APT satellite imagery decoding library";
    homepage = "https://github.com/Xerbo/aptdec";
    license = licenses.gpl2;
    maintainers = with maintainers; [ alexwinter ];
    platforms = platforms.linux;
  };
}
