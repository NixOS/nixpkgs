{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wishlist";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "wishlist";
    rev = "v${version}";
    sha256 = "sha256-NSL67j/nnE6Ftm39XNav3/TPUSFXHxQE5OxpNEIdtVc=";
  };

  vendorHash = "sha256-8TQkzsvHjdkYXVmUKaqbs7nURx8kUv2HGs9cBv3hPJc=";

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
