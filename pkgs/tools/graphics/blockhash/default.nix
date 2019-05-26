{ stdenv, fetchFromGitHub, python, pkgconfig, imagemagick, wafHook }:

stdenv.mkDerivation rec {
  name = "blockhash-${version}";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "commonsmachinery";
    repo = "blockhash";
    rev = "v${version}";
    sha256 = "0m7ikppl42iicgmwsb7baajmag7v0p1ab06xckifvrr0zm21bq9p";
  };

  nativeBuildInputs = [ python pkgconfig wafHook ];
  buildInputs = [ imagemagick ];

  meta = with stdenv.lib; {
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
