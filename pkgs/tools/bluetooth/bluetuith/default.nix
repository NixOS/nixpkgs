{ buildGoModule, fetchFromGitHub, lib, stdenv }:

buildGoModule rec {
  pname = "bluetuith";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "darkhz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Xcj+1zSAgizj5e1VY77ma8i9XEuDaebyNZJcFCsNYwI=";
  };

  vendorSha256 = "sha256-vPVfI2MXrUEvx/jlt6A3EEHiyiy4R3FSw3UnF76ZZho=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "TUI-based bluetooth connection manager";
    homepage = "https://github.com/darkhz/bluetuith";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ thehedgeh0g ];
  };
}
