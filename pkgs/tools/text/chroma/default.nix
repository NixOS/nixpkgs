{ lib, buildGoModule, fetchFromGitHub }:

let
  srcInfo = lib.importJSON ./src.json;
in

buildGoModule rec {
  pname = "chroma";
  version = "2.2.0";

  # To update:
  # nix-prefetch-git --rev v${version} https://github.com/alecthomas/chroma.git > src.json
  src = fetchFromGitHub {
    owner  = "alecthomas";
    repo   = pname;
    rev    = "v${version}";
    inherit (srcInfo) sha256;
  };

  vendorSha256 = "1f5pv32vg0ci71kj5bbg24ymmm12yi6r07n8blj47qz8203l5yab";

  modRoot = "./cmd/chroma";

  # substitute version info as done in goreleaser builds
  ldflags = [
    "-X" "main.version=${version}"
    "-X" "main.commit=${srcInfo.rev}"
    "-X" "main.date=${srcInfo.date}"
  ];

  meta = with lib; {
    homepage = "https://github.com/alecthomas/chroma";
    description = "A general purpose syntax highlighter in pure Go";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
