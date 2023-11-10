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
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    rev = "gping-v${version}";
    hash = "sha256-22Nio6yfkL9HWNrI+kk5dGfojTtB/h0sizCWH9w9so8=";
  };

  cargoHash = "sha256-YfvcCnFXDoZXp/Aug0jVQkilsvSzS+JF90U0QvVFksE=";

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
