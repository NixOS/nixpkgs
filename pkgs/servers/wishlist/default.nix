{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wishlist";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "wishlist";
    rev = "v${version}";
    sha256 = "sha256-NOR7YCLcwjf+oAi46qL6NteKLMSvJpqu9UzO6UvgcVQ=";
  };

  vendorHash = "sha256-v8R0e52CpyLKiuYcEZFWAY64tgCBZE2dY0vgqsHWeAc=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "A single entrypoint for multiple SSH endpoints";
    homepage = "https://github.com/charmbracelet/wishlist";
    changelog = "https://github.com/charmbracelet/wishlist/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ caarlos0 penguwin ];
  };
}
