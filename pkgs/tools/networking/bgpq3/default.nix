{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "bgpq3";
  version = "0.1.36.1";

  src = fetchFromGitHub {
    owner = "snar";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rOpggVlXKaf3KBhfZ2lVooDaQA0iRjSbsLXF02GEyBw=";
  };

  # Fix binary install location. Remove with next upstream release.
  preInstall = "mkdir -p $out/bin";

  meta = with lib; {
    description = "bgp filtering automation tool";
    homepage = "https://github.com/snar/bgpq3";
    license = licenses.bsd2;
    maintainers = with maintainers; [ b4dm4n ];
    platforms = with platforms; unix;
  };
}
