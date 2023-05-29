{ lib
, fetchFromGitHub
, buildGoModule
, installShellFiles
}:

buildGoModule rec {
  pname = "logo-ls";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "Yash-Handa";
    repo = "logo-ls";
    rev = "v${version}";
    hash = "sha256-jxUowWhvtFJ5EyYVzmNmgNQ2/MOR1VU3TY10t2j615c=";
  };

  vendorHash = "sha256-p0rM8dZwwwARh2crtOkq1HtJKnxsvLKg1Bhm/5mtESM=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage logo-ls.1.gz
  '';

  meta = with lib; {
    description = "Modern ls command with vscode like File Icon and Git Integrations";
    homepage = "https://github.com/Yash-Handa/logo-ls";
    changelog = "https://github.com/Yash-Handa/logo-ls/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
}
