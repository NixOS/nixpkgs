{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {

  name = "supervise-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "catern";
    repo = "supervise";
    rev = "v${version}";
    sha256 = "1cjdxgns3gh2ir4kcmjdmc480w8sm49inws0ihhjmnisjy4100lg";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp supervise unlinkwait -t $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/catern/supervise;
    description = "A minimal unprivileged process supervisor making use of modern Linux features";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ catern ];
  };
}
