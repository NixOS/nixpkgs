{ lib, stdenv, rustPlatform, fetchFromGitHub, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "bacon";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wyx216q9q7y60bnnw4cbpv9zlbnjm2hwq0llkjw60fp3qalj9am";
  };

  cargoSha256 = "1pii5ajl3xgylrm20pkwbd1lk7gv0pshl1cxjfna0l63q56v7f21";

  buildInputs = lib.optional stdenv.isDarwin CoreServices;

  meta = with lib; {
    description = "Background rust code checker";
    homepage = "https://github.com/Canop/bacon";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
