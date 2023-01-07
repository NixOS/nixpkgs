{ lib, stdenv, rustPlatform, fetchFromGitHub, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "bacon";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vmvv08cAYNfzlHXrCwfL37U39TS8VQIOJGMgDHc99ME=";
  };

  cargoHash = "sha256-2HR0ClsbCjHiZKmPJkv3NnJyDmdR1rw+TD7UuHLk1Sg=";

  buildInputs = lib.optional stdenv.isDarwin CoreServices;

  meta = with lib; {
    description = "Background rust code checker";
    homepage = "https://github.com/Canop/bacon";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
