{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "bgpq3";
  version = "0.1.36";

  src = fetchFromGitHub {
    owner = "snar";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FBtt++w2WzCnSim+r+MVy287w2jmdNEaQIro2KaVeRI=";
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
