{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bluetuith";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "darkhz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vdHnG0uQdy5PboIovtxl5i9xwFpjYLCZf2IGeiMcWe8=";
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
