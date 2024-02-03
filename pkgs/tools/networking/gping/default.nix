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
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    rev = "gping-v${version}";
    hash = "sha256-ReP+s2p0X39LVvl3/QF7fsYkU+OvsQyMhyuH8v4HuVU=";
  };

  cargoHash = "sha256-FTiNxCoEe/iMz68F1CpJHypgrhn4WwwWowuN9I1rl6E=";

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
