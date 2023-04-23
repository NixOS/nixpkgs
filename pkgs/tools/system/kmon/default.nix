{ lib, rustPlatform, fetchFromGitHub, installShellFiles, libxcb }:

rustPlatform.buildRustPackage rec {
  pname = "kmon";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lB6vJqb6/Qwj3odCJzyQ0+xEl5V/ZPj9cAJGNfiYAOY=";
  };

  cargoSha256 = "sha256-Ff5vGc90VxmyKQSsjUfoI1NL95DmD1SJx3eC1SP6rt4=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ libxcb ];

  postInstall = ''
    installManPage $releaseDir/../man/kmon.8
    installShellCompletion $releaseDir/../completions/kmon.{bash,fish} \
      --zsh $releaseDir/../completions/_kmon
  '';

  meta = with lib; {
    description = "Linux Kernel Manager and Activity Monitor";
    homepage = "https://github.com/orhun/kmon";
    changelog = "https://github.com/orhun/kmon/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ figsoda misuzu ];
  };
}
