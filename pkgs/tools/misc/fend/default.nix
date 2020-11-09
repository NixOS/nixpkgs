{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "fend";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "printfn";
    repo = pname;
    rev = "v${version}";
    sha256 = "11cvpg7j2rvqri16cr3gb6dpm7dzgs3vywhdc91aa531f87qj16c";
  };

  cargoSha256 = "0q9gkvbay6rnb0nd14z71h3506yzn9610zc6g8wbpgmw6cpwvbg9";

  meta = with lib; {
    description = "Arbitrary-precision unit-aware calculator";
    homepage = "https://github.com/printfn/fend";
    license = licenses.mit;
    maintainers = with maintainers; [ djanatyn ];
  };
}
