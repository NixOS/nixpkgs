{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "srisum";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "zkat";
    repo = "srisum-rs";
    rev = "v${version}";
    hash = "sha256-Nw3uTGOcz1ivAm9X+PnOdNA937wuK3vtJQ0iJHlHVdw=";
  };
  cargoHash = "sha256-q6FGykY+HmU3/jMaGRO36OlYGVLG9mU8yZ8j/Shux3s=";

  doInstallCheck = true;

  meta = with lib; {
    description = "A command-line utility to compute and check subresource integrity hashes";
    homepage = "https://github.com/zkat/srisum-rs";
    changelog = "https://github.com/zkat/srisum-rs/raw/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ pjjw ];
    platforms = platforms.all;
    mainProgram = "srisum";
  };
}
