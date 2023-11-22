{ lib
, rustPlatform
, fetchFromGitHub
, libsixel
, withSixel ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "viu";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "atanunq";
    repo = "viu";
    rev = "v${version}";
    hash = "sha256-GJBJNtcCDO777NdxLBVj5Uc4PSJq3CE785eGKCPWt0I=";
  };

  # tests need an interactive terminal
  doCheck = false;

  cargoHash = "sha256-284ptMBVF4q57wTiCuTuYUiYMYItKf4Tyf6AtY0fqDk=";

  buildFeatures = lib.optional withSixel "sixel";
  buildInputs = lib.optional withSixel libsixel;

  meta = with lib; {
    description = "A command-line application to view images from the terminal written in Rust";
    homepage = "https://github.com/atanunq/viu";
    license = licenses.mit;
    maintainers = with maintainers; [ chuangzhu ];
  };
}
