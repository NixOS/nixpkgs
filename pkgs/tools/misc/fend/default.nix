{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "fend";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "printfn";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gs9hmkc25013nk8b7d7pcxcp4jmk4pa4gcki3wgvlrzjl1av7w4";
  };

  cargoSha256 = "13lw7isg9lfn6dfngq15qbq619c644ixa5bvb1ja0l3hm3akrs5g";

  meta = with lib; {
    description = "Arbitrary-precision unit-aware calculator";
    homepage = "https://github.com/printfn/fend";
    license = licenses.mit;
    maintainers = with maintainers; [ djanatyn ];
  };
}
