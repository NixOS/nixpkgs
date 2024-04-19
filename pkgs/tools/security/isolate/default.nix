{ lib
, stdenv
, fetchFromGitHub
, asciidoc
, libcap
, systemdLibs
, pkg-config
, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "isolate";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "ioi";
    repo = "isolate";
    rev = "v${version}";
    hash = "sha256-kKXkXPVB9ojyIERvEdkHkXC//Agin8FPcpTBmTxh/ZE=";
  };

  nativeBuildInputs = [
    asciidoc
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    libcap.dev
    systemdLibs.dev
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 ./isolate $out/bin/isolate
    install -Dm755 ./isolate-cg-keeper $out/bin/isolate-cg-keeper
    install -Dm755 ./isolate-check-environment $out/bin/isolate-check-environment
    install -Dm644 ./systemd/* -t $out/lib/systemd/system/
    installManPage isolate.1

    runHook postInstall
  '';

  meta = {
    description = "Sandbox for securely executing untrusted programs";
    mainProgram = "isolate";
    homepage = "https://github.com/ioi/isolate";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ virchau13 ];
  };
}
