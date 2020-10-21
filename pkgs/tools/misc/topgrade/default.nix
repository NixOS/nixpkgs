{ stdenv, lib, fetchFromGitHub, rustPlatform, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "5.7.0";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "0nxqi2rykfxhvn8jzprklsc47iilxp1pmm2f17ikfyf5dgi69whb";
  };

  cargoSha256 = "05afmz2n006331hc8yi2mq9kj574xi1iq6gr983jj75ix7n40rgg";

  buildInputs = lib.optional stdenv.isDarwin Foundation;

  # TODO: add manpage (topgrade.8) to postInstall on next update

  meta = with lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/r-darwish/topgrade";
    license = licenses.gpl3;
    maintainers = with maintainers; [ filalex77 hugoreeves ];
  };
}
