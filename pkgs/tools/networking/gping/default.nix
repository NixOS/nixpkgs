{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "gping";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    rev = "v${version}";
    sha256 = "0sdv6mf7mrgsdinv94mhai5jaw04s6r9cq0wxkph9b4hhywi0lys";
  };

  cargoSha256 = "0rrqjlyn7k8f7ndzra16a9k4l6mjfim84lfi886q3irbn234b1va";

  meta = with lib; {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };
}
