{ buildGoModule, fetchFromGitHub, lib, stdenv }:

buildGoModule rec {
  pname = "bluetuith";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "darkhz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kt7Kbd7VNVnNwSXEzGrMQTu9xsjF90ZoYKYdJQtuPFE=";
  };

  vendorSha256 = "sha256-zXt0o0hlpD3lkrxiV+d6OM3OiArdRZ5JT341YCHwMl0=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "TUI-based bluetooth connection manager";
    homepage = "https://github.com/darkhz/bluetuith";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ thehedgeh0g ];
  };
}
