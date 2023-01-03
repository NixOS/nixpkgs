{ lib, stdenv, rustPlatform, fetchFromGitHub, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "bacon";
  version = "2.2.8";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UFuU3y+v1V7Llc+IrWbh7kz8uUyCsxJO2zJhE6zwjSg=";
  };

  cargoSha256 = "sha256-CPugHGkYbJG6WrguuGt/CnHq6NvRZ2fP2hgPIuIGGqc=";

  buildInputs = lib.optional stdenv.isDarwin CoreServices;

  meta = with lib; {
    description = "Background rust code checker";
    homepage = "https://github.com/Canop/bacon";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
