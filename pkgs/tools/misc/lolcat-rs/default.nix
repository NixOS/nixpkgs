{ lib, fetchgit, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "lolcat-rs";
  version = "1.5.0";

  src = fetchgit {
    # owner = "ur0";
    url = "https://github.com/ur0/lolcat.git";
    rev = "9621f625e1d4e7b3294facdc7a2c1cf866af722e";
    hash = "sha256-zy8BD2F49H5jdHxMMlqUJQkHePkrApRL088xC79oP5g=";
  };

  cargoHash = "sha256-hfcQsB4c+0/BmAV7Q0NUcGjedc35teDGRv5fDyyvp2c=";

  meta = with lib; {
    description = "A rainbow version of cat, implemented in Rust for speed";
    homepage = "https://github.com/ur0/lolcat";
    license = licenses.mit;
    maintainers = with maintainers; [ mirrorwitch ];
  };
}
