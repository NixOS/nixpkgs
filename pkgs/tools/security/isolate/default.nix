{ lib
, stdenv
, fetchFromGitHub
, asciidoc
, libcap
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
  ];

  buildInputs = [
    libcap.dev
  ];

  buildFlags = [
    "isolate"
    "isolate.1"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 ./isolate $out/bin/isolate
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
