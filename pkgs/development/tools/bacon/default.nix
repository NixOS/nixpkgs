{ lib, stdenv, rustPlatform, fetchFromGitHub, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "bacon";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VM+suU3PLxGWXVIH26hbXFIfvRuJicLJX8D8fo1mZCM=";
  };

  cargoSha256 = "sha256-FgqYKmCEBbyv6+2GD5NwEvRz3582IZtkuVPaAT77bvY=";

  buildInputs = lib.optional stdenv.isDarwin CoreServices;

  meta = with lib; {
    description = "Background rust code checker";
    homepage = "https://github.com/Canop/bacon";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
