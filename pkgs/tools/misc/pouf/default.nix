{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "pouf";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "mothsart";
    repo = pname;
    rev = version;
    sha256 = "1zz91r37d6nqvdy29syq853krqdkigiqihwz7ww9kvagfvzvdh13";
  };

  cargoSha256 = "1ikm9fqi37jznln2xsyzfm625lv8kwjzanpm3wglx2s1k1jkmcy9";

  postInstall = "make PREFIX=$out copy-data";

  meta = with lib; {
    description = "A cli program for produce fake datas.";
    homepage = "https://github.com/mothsart/pouf";
    changelog = "https://github.com/mothsart/pouf/releases/tag/${version}";
    maintainers = with maintainers; [ mothsart ];
    license = with licenses; [ mit ];
  };
}
