{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "wait-for-it-unstable";
  version = "unstable-2020-02-05";

  src = fetchFromGitHub {
    owner = "vishnubob";
    repo = "wait-for-it";
    rev = "c096cface5fbd9f2d6b037391dfecae6fde1362e";
    sha256 = "1k1il4bk8l2jmfrrcklznc8nbm69qrjgxm20l02k01vhv2m2jc85";
  };
  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];
  installPhase = ''
    runHook preInstall

    install -D ./wait-for-it.sh  $out/bin/wait-for-it

    runHook postInstall
  '';
  meta = {
    homepage = "https://github.com/vishnubob/wait-for-it";
    description =
      "Pure bash script to test and wait on the availability of a TCP host and port";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.silviogutierrez ];
  };
}
