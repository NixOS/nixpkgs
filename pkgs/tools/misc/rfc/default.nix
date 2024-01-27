{ lib
, stdenvNoCC
, fetchFromGitHub
, curl
, installShellFiles
, makeWrapper
}:

stdenvNoCC.mkDerivation rec {
  pname = "rfc";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "bfontaine";
    repo = "rfc";
    rev = "v${version}";
    hash = "sha256-dfaeTdJiJuKp8/k6LBP+RC60gTRHfHR5hhLD4ZWJufE=";
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin rfc
    wrapProgram $out/bin/rfc \
      --prefix PATH : ${lib.makeBinPath [ curl ]}
    installManPage man/rfc.1

    runHook postInstall
  '';

  meta = with lib; {
    description = "A tool to read RFCs from the command line";
    longDescription = ''
      rfc is a little tool written in Bash to read RFCs from the command-line.
      It fetches RFCs and drafts from the Web and caches them locally.
    '';
    homepage = "https://github.com/bfontaine/rfc";
    changelog = "https://github.com/bfontaine/rfc/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.all;
    mainProgram = "rfc";
  };
}
