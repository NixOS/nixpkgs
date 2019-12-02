{stdenv, fetchFromGitHub}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "fbvnc";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "zohead";
    repo = pname;
    sha256 = "0lkr4j1wsa05av2g9w99rr9w4j4k7a21vp36x0a3h50y8bmgwgm1";
    rev = "783204ff6c92afec33d6d36f7e74f1fcf2b1b601";
  };

  buildInputs = [];

  installPhase = ''
    mkdir -p "$out/bin"
    cp fbvnc "$out/bin"
    mkdir -p "$out/share/doc/${pname}"
    cp README* "$out/share/doc/${pname}"
  '';

  meta = {
    description = "Framebuffer VNC client";
    license = stdenv.lib.licenses.bsd3;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "https://github.com/zohead/fbvnc/";
  };
}
