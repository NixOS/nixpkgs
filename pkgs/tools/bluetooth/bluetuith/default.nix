{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bluetuith";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "darkhz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5Jn5qkCUj2ohpZU+XqR90Su2svcLqW+hW6kmeEVfrtI=";
  };

  vendorHash = "sha256-pYVEFKLPfstWWO6ypgv7ntAaE1Wmq2XKuZC2ccMa8Vc=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "TUI-based bluetooth connection manager";
    homepage = "https://github.com/darkhz/bluetuith";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "bluetuith";
    maintainers = with maintainers; [ thehedgeh0g ];
  };
}
