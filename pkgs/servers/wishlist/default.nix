{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wishlist";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "wishlist";
    rev = "v${version}";
    sha256 = "sha256-B4p2j/U+vTiku7rTj5Ho6BY84kjrNHLDIkI9pZZdmHI=";
  };

  vendorHash = "sha256-kfeIEpe6g4T9joAZesgqdE5dd9UD9+a0nALceKq1/zc=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Single entrypoint for multiple SSH endpoints";
    homepage = "https://github.com/charmbracelet/wishlist";
    changelog = "https://github.com/charmbracelet/wishlist/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ caarlos0 penguwin ];
    mainProgram = "wishlist";
  };
}
