{ lib
, rustPlatform
, fetchFromGitLab
, installShellFiles
, pam
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "please";
  version = "0.5.3";

  src = fetchFromGitLab {
    owner = "edneville";
    repo = "please";
    rev = "v${version}";
    hash = "sha256-YL0yKIDoFD6Q5gVXOjHiqH2ub7jlhlE/uDKLK1FlE74=";
  };

  cargoHash = "sha256-noZsnFL6G1KcxGY0sn0PvY5nIdx5aOAMErMViIY/7bE=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ pam ];

  patches = [ ./nixos-specific.patch ];

  postInstall = ''
    installManPage man/*
  '';

  passthru.tests = { inherit (nixosTests) please; };

  meta = with lib; {
    description = "A polite regex-first sudo alternative";
    longDescription = ''
      Delegate accurate least privilege access with ease. Express easily with a
      regex and expose only what is needed and nothing more. Or validate file
      edits with pleaseedit.

      Please is written with memory safe rust. Traditional C memory unsafety is
      avoided, logic problems may exist but this codebase is relatively small.
    '';
    homepage = "https://www.usenix.org.uk/content/please.html";
    changelog = "https://github.com/edneville/please/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.linux;
  };
}
