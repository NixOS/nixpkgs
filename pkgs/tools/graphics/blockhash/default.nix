{ lib, stdenv, fetchFromGitHub, python2, pkg-config, imagemagick, wafHook }:

stdenv.mkDerivation rec {
  pname = "blockhash";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "commonsmachinery";
    repo = "blockhash";
    rev = "v${version}";
    sha256 = "0m7ikppl42iicgmwsb7baajmag7v0p1ab06xckifvrr0zm21bq9p";
  };

  nativeBuildInputs = [ python2 pkg-config wafHook ];
  buildInputs = [ imagemagick ];

  strictDeps = true;

  meta = with lib; {
    homepage = "http://blockhash.io/";
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
