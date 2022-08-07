{ buildGoModule, fetchFromGitHub, lib, stdenv }:

buildGoModule rec {
  pname = "bluetuith";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "darkhz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HQIcHOZf7jDYaG4RnhWDTk6CRu55IfGZevbWixlNE2M=";
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
