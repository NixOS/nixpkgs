{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "gping";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    rev = "gping-v${version}";
    sha256 = "sha256-Q7M/vDhECEIQ8s8qt1U7wESqv+Im79TyZ6s2vqjU5ps=";
  };

  cargoSha256 = "sha256-cnmjfvMqq8VDMvjFPnjmmH57Gaqttk36AwEtuuAT6qU=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/gping --version | grep "${version}"
  '';

  meta = with lib; {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };
}
