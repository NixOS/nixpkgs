{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libiconv
, Security
, iputils
}:

rustPlatform.buildRustPackage rec {
  pname = "gping";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    rev = "gping-v${version}";
    hash = "sha256-EkoOHyHYcbyqtT1zCq0kmXND1eSADE7QD3QQ01RJtvM=";
  };

  cargoHash = "sha256-iDB3ZIlSLEBf+nSxLeQcE93nqMjH29w+z7kwCNksuSk=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  nativeCheckInputs = lib.optionals stdenv.isLinux [ iputils ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/gping --version | grep "${version}"
  '';

  meta = with lib; {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    changelog = "https://github.com/orf/gping/releases/tag/gping-v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };
}
