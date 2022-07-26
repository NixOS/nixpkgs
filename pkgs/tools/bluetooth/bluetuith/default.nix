{ buildGoModule, fetchFromGitHub, lib, stdenv }:

buildGoModule rec {
  pname = "bluetuith";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "darkhz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7JqpF9iga6RO+/r2JK0N9gjieVRUNkHhGNsfVFfKfRY=";
  };

  vendorSha256 = "sha256-MsVrhEG2DOFJAXvt5rvfctGUbb3hQsBJ7cjOSzWA+bc=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "TUI-based bluetooth connection manager";
    homepage = "https://github.com/darkhz/bluetuith";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ thehedgeh0g ];
  };
}
