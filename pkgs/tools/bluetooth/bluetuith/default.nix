{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bluetuith";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "darkhz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8FVXVawmaCgnsexnNRw53tVR2a2fRyDK+h959Ezw7Zg=";
  };

  vendorHash = "sha256-mudJN7rYWpdv2X4hrYjPBtEILyrdext4q+maDK1dC44=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "TUI-based bluetooth connection manager";
    homepage = "https://github.com/darkhz/bluetuith";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ thehedgeh0g ];
  };
}
