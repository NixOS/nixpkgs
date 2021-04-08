{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-feature";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "Riey";
    repo = pname;
    rev = "v${version}";
    sha256 = "0n5kzh756ghfs3cydlcn9mfvpgwy1cjg41h0nd9dbi5cr1fp9x1n";
  };

  cargoSha256 = "0nvl5smibl81b826xcsrjx8p89lcfpj7wqdsvywnj7jd3p5ag03n";

  meta = with lib; {
    description = "Allows conveniently modify features of crate";
    homepage = "https://github.com/Riey/cargo-feature";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ riey ];
  };
}

