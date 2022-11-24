{ lib, nix-update-script, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goda";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "loov";
    repo = "goda";
    rev = "v${version}";
    sha256 = "sha256-qBuhwIQvfUZMyzCJ/7Kedc+InrGwpcLhDLvX9i0ws2A=";
  };

  vendorSha256 = "sha256-BYYuB4ZlCWD8NILkf4qrgM4q72ZTy7Ze3ICUXdoI5Ms=";

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    homepage = "https://github.com/loov/goda";
    description = "Go Dependency Analysis toolkit";
    maintainers = with maintainers; [ michaeladler ];
    license = licenses.mit;
    mainProgram = "goda";
  };
}
