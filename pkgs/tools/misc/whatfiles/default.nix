{ lib, stdenv, fetchFromGitHub, makeWrapper}:

stdenv.mkDerivation {
  pname = "whatfiles-unstable";
  version = "2020-06-16";

  src = fetchFromGitHub {
    owner = "spieglt";
    repo = "whatfiles";
    rev  = "2e12e73fec9683d95397b032fc3220ee00377ccc";
    sha256 = "1l326ra8x38f3v99b7izcg6rwrl6dxps9xbp6ca0r711fdgaf1lg";
  };

  installPhase = ''
    install -Dm755 bin/whatfiles $out/bin/whatfiles
  '';

  meta = with lib; {
    description = "Log what files are accessed by any Linux process";
    homepage = "https://github.com/spieglt/whatfiles";
    maintainers = [ maintainers.matthiasbeyer ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
