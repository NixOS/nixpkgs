{ SDL2 , SDL2_image, SDL2_ttf, SDL2_mixer
, stdenv, pkgconfig, icu, boost, glew, cairo
, fetchgit, which
}:
stdenv.mkDerivation {
  name = "anura";
  version = "20171110";

  nativeBuildInputs = [  pkgconfig icu.dev which ];
  buildInputs = [ boost SDL2.dev SDL2_image SDL2_mixer SDL2_ttf glew cairo ];

  installPhase = ''
      mkdir -p $out/bin
      install -p anura $out/bin/anura
  '';

  src = fetchgit {
    url = https://github.com/anura-engine/anura.git;
    rev = "fee247c573005777de9f6eb67debc83988818898";
    fetchSubmodules = true;
    sha256 = "03j6ld0g8kh5x6d2qna1rrp8jzs587a5zw2qz71w5ryqn8w4jdil";
  };

  meta = with stdenv.lib; {
    description = "Game engine used by argentum, frogatto";
    licenses = licenses.gpl3;
    homepage = https://github.com/anura-engine/anura;
    maintainers = [ maintainers.teto ];
  };
}
