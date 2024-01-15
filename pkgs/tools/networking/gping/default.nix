{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, libiconv
, Security
, iputils
}:

rustPlatform.buildRustPackage rec {
  pname = "gping";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    rev = "gping-v${version}";
    hash = "sha256-t9USry3I6tc8EKsfkq28/hPJMbaf0BqqOdzCl3oXd60=";
  };

  cargoHash = "sha256-QERmZOyC4U6ZpCkL7ap5MRvPEE2vqK/tD+CrBLg07J0=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = lib.optionals stdenv.isLinux [ iputils ];

  postInstall = ''
    installManPage gping.1
  '';

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
