{ lib, rustPlatform, fetchFromGitea }:

rustPlatform.buildRustPackage rec {
  pname = "seehecht";
  version = "3.0.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = "seehecht";
    rev = "v${version}";
    sha256 = "sha256-KIxK0JYfq/1Bn4LOn+LzWPBUvGYMvOEuqS7GMpDRvW0=";
  };

  cargoSha256 = "sha256-AeVUVF4SBS9FG0iezLBKUm4Uk1PPRXPTON93evgL9IA=";

  postInstall = ''
    ln -s $out/bin/seh $out/bin/seehecht
  '';

  meta = with lib; {
    description = "Tool to quickly open a markdown document with already filled out frontmatter";
    license = licenses.lgpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ annaaurora ];
  };
}
