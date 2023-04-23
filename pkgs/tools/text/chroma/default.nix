{ lib, buildGoModule, fetchFromGitHub }:

let
  srcInfo = lib.importJSON ./src.json;
in

buildGoModule rec {
  pname = "chroma";
  version = "2.7.0";

  # To update:
  # nix-prefetch-git --rev v${version} https://github.com/alecthomas/chroma.git > src.json
  src = fetchFromGitHub {
    owner  = "alecthomas";
    repo   = pname;
    rev    = "v${version}";
    inherit (srcInfo) sha256;
  };

  vendorSha256 = "0kw53983bjrmh9nk2xcv4d9104krxnc1jh1g44xjmaq8i6f3q0k1";

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
