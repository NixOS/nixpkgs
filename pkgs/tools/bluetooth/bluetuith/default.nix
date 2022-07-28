{ buildGoModule, fetchFromGitHub, lib, stdenv }:

buildGoModule rec {
  pname = "bluetuith";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "darkhz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NXQa3aOjTIcQQZNwkS5ypBp7jzUhXztJ6LgtucIEDYI=";
  };

  vendorSha256 = "sha256-sCpJow5tiliiNSnKjgzxmgyHxPk8j1RdjobFwKhpU4w=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "TUI-based bluetooth connection manager";
    homepage = "https://github.com/darkhz/bluetuith";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ thehedgeh0g ];
  };
}
