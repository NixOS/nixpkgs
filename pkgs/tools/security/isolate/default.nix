{ lib
, stdenv
, fetchFromGitHub
, asciidoc
, libcap
, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "isolate";
  version = "1.10";

  src = fetchFromGitHub {
    owner = "ioi";
    repo = "isolate";
    rev = "v${version}";
    hash = "sha256-fuv9HOw0XkRBRjwAp4b6LpoB5p7a+yo66AcT3B0yQUw=";
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
    homepage = "https://github.com/ioi/isolate";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ virchau13 ];
  };
}
