{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "battop";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "svartalf";
    repo = "rust-battop";
    rev = "v${version}";
    sha256 = "0p53jl3r2p1w9m2fvhzzrj8d9gwpzs22df5sbm7wwja4pxn7ay1w";
  };

  # https://github.com/svartalf/rust-battop/issues/11
  cargoPatches = [ ./battery.patch ];

  cargoSha256 = "0ipmnrn6lmf6rqzsqmaxzy9lblrxyrxzkji968356nxxmwzfbfvh";

  meta = with lib; {
    description = "is an interactive battery viewer";
    homepage = "https://github.com/svartalf/rust-battop";
    license = licenses.asl20;
    maintainers = with maintainers; [ hdhog ];
  };
}
