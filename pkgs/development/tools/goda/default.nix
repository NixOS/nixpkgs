{ lib, nix-update-script, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goda";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "loov";
    repo = "goda";
    rev = "v${version}";
    sha256 = "sha256-yKhgk/DRcifh+exxTZFti1Aac/sgpvUsNKdioLAzmX0=";
  };

  vendorSha256 = "sha256-BYYuB4ZlCWD8NILkf4qrgM4q72ZTy7Ze3ICUXdoI5Ms=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/loov/goda";
    description = "Go Dependency Analysis toolkit";
    maintainers = with maintainers; [ michaeladler ];
    license = licenses.mit;
    mainProgram = "goda";
  };
}
