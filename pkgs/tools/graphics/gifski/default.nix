{ lib, rustPlatform, fetchFromGitHub, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "sha256-mM+gxBmMsdPUBOYyRdomd5+v+bqGN+udcuXI/stMZ4Y=";
  };

  cargoSha256 = "sha256-5effx4tgMbnoVMO2Fza1naGFnMCvm0vhx6njo9/8bq0=";

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "GIF encoder based on libimagequant (pngquant)";
    homepage = "https://gif.ski/";
    license = licenses.agpl3;
    maintainers = [ maintainers.marsam ];
  };
}
