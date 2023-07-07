{ buildGoModule, fetchFromGitHub, lib, stdenv }:

buildGoModule rec {
  pname = "bluetuith";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "darkhz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ii81XrIOhJNQtQWeLSqWCE4xhJOcXTzgnXm2Z20HvHo=";
  };

  vendorHash = "sha256-eSgjIZmD5HL8S1XY0LK2IeWDchjFWBlRq5qriBg7l2U=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "TUI-based bluetooth connection manager";
    homepage = "https://github.com/darkhz/bluetuith";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ thehedgeh0g ];
  };
}
