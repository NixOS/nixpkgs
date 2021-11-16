{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "rates";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "lunush";
    repo = pname;
    rev = version;
    sha256 = "077qxs4kwfprsai07dninkhmj3ihnghdxan98iv8gmsl3pijbgwh";
  };

  cargoSha256 = "041sskiq152iywwqd8p7aqsqzbj359zl7ilnp8ahzdqprz3slk1w";

  meta = with lib; {
    description = "CLI tool that brings currency exchange rates right into your terminal";
    homepage = "https://github.com/lunush/rates";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
