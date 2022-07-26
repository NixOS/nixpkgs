{ lib, rustPlatform, fetchFromGitea }:

rustPlatform.buildRustPackage rec {
  pname = "seehecht";
  version = "3.0.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = "seehecht";
    rev = "v${version}";
    sha256 = "sha256-x5zZEDaBmWpyvY+sKuiK4L+hc85prxCueWYUNMi9ty0=";
  };

  cargoSha256 = "sha256-mWGmMtUYeM97SM+/jtOzkAe1usuZT4yOI6PAbiGKe7M=";

  postInstall = ''
    ln -s $out/bin/seh $out/bin/seehecht
  '';

  meta = with lib; {
    description = "A tool to quickly open a markdown document with already filled out frontmatter";
    license = licenses.lgpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ annaaurora ];
  };
}
