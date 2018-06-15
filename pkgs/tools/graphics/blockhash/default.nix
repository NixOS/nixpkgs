{ stdenv, fetchFromGitHub, python, pkgconfig, imagemagick }:

stdenv.mkDerivation rec {
  name = "blockhash-${version}";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "commonsmachinery";
    repo = "blockhash";
    rev = "v${version}";
    sha256 = "15iwljpkykn2711jhls7cwkb23gk6iawlvvk4prl972wic2wlxcj";
  };

  nativeBuildInputs = [ python pkgconfig ];
  buildInputs = [ imagemagick ];

  configurePhase = "python waf configure --prefix=$out";
  buildPhase = "python waf";
  installPhase = "python waf install";

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
