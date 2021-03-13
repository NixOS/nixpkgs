{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "resvg";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fd97w6yd9ZX2k8Vq+Vh6jouufGdFE02ZV8mb+BtA3tk=";
  };

  cargoSha256 = "sha256-LlEYfjUINQW/YrhNp/Z+fdLQPcvrTjNFtDAk1gyAuj0=";

  doCheck = false;

  meta = with lib; {
    description = "An SVG rendering library";
    homepage = "https://github.com/RazrFalcon/resvg";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
