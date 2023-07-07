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
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    rev = "gping-v${version}";
    hash = "sha256-0+qSBnWewWg+PE5y9tTLLaB/uxUy+9uQkR1dnsk7MIY=";
  };

  cargoHash = "sha256-N2V6Wwb2YB2YlBjyHZrh73RujTAmgsFOBLiN/SILP1k=";

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
