{ lib, stdenv, rustPlatform, fetchFromGitHub, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "bacon";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dpdQ1qBfLU6whkqVHQ/zQxqs/y+nmdvxHanaNw66QxA=";
  };

  cargoSha256 = "sha256-jidZhaB8gF4QBcTvVuygTZdQnlOVwOQO8MMjUuSPht0=";

  buildInputs = lib.optional stdenv.isDarwin CoreServices;

  meta = with lib; {
    description = "Background rust code checker";
    homepage = "https://github.com/Canop/bacon";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
