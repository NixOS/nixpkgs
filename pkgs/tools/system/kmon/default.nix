{ lib, rustPlatform, fetchFromGitHub, installShellFiles, libxcb }:

rustPlatform.buildRustPackage rec {
  pname = "kmon";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-61HLWSGACnonjp/n14sVo8DdVOUbOpIQHpPL0PmKmpI=";
  };

  cargoSha256 = "sha256-yxpM4aUPVfaMuYwj50C/Uwh/diraJLON1mNjuYJR6Ck=";

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
    maintainers = with maintainers; [ figsoda misuzu matthiasbeyer ];
    mainProgram = "kmon";
  };
}
