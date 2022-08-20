{ stdenv, lib, rustPlatform, fetchFromGitHub, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "sha256-Y2gNVm8Ziq3ipfgqRLbw1Hrd0ry556b78riWCo9sg3s=";
  };

  cargoSha256 = "sha256-KH+RoPilgigBzvQaY542Q9cImNVeYlL7QGnslBWHtwE=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  # error: the crate `gifski` is compiled with the panic strategy `abort` which is incompatible with this crate's strategy of `unwind`
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "GIF encoder based on libimagequant (pngquant)";
    homepage = "https://gif.ski/";
    license = licenses.agpl3;
    maintainers = [ maintainers.marsam ];
  };
}
