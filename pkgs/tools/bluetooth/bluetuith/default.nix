{ buildGoModule, fetchFromGitHub, lib, stdenv }:

buildGoModule rec {
  pname = "bluetuith";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "darkhz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3rN82Ywr7iJk3f+RvyqPRirDUQuRksAFf5TzCXk8fgo=";
  };

  vendorSha256 = "sha256-/CEQfpE5ENpfWQ0OvMaG9rZ/4BtFm21JkqDZtHwzqNU=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "TUI-based bluetooth connection manager";
    homepage = "https://github.com/darkhz/bluetuith";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ thehedgeh0g ];
  };
}
