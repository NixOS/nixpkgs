{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bluetuith";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "darkhz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-b+J+8nxFZYJlAKOStpH7ItPqMw7inM5pss17kyX1brg=";
  };

  vendorHash = "sha256-d0O54KNGLXU8FGr1eSEp30JMWNVo91Le2MI8UnAfTuU=";

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
