{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "lethe";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "kostassoid";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WYDO44S2cBPe14vv/4i51tgtnoR+6FN2GyAbjJ7AYy8=";
  };

  cargoSha256 = "sha256-5fWclZgt5EuWrsYRheTX9otNiGbJ41Q/fTYdKMWRMHc=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Tool to wipe drives in a secure way";
    homepage = "https://github.com/kostassoid/lethe";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
