{ lib, stdenv, fetchFromGitHub, python3, pkg-config, imagemagick, waf }:

stdenv.mkDerivation rec {
  pname = "blockhash";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "commonsmachinery";
    repo = "blockhash";
    rev = "v${version}";
    sha256 = "0x3lvhnkb4c3pyq6p81qnnqimz35wpippiac506dgjx3b1848v35";
  };

  nativeBuildInputs = [ python3 pkg-config waf.hook ];
  buildInputs = [ imagemagick ];

  strictDeps = true;

  meta = with lib; {
    homepage = "https://github.com/commonsmachinery/blockhash";
    description = ''
      This is a perceptual image hash calculation tool based on algorithm
      descibed in Block Mean Value Based Image Perceptual Hashing by Bian Yang,
      Fan Gu and Xiamu Niu.
    '';
    license = licenses.mit;
    maintainers = [ maintainers.infinisil ];
    platforms = platforms.unix;
  };
}
