{ stdenv, fetchFromGitHub, rustPlatform, pkgs }:

rustPlatform.buildRustPackage rec {
  pname = "httplz";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "thecoshman";
    repo = "http";
    rev = "v${version}";
    sha256 = "0mb2wifz8pba03bdpiqadih33jimhg9crs4b72rcyfmj9l8fd1ba";
  };

  buildInputs = with pkgs; [ openssl pkgconfig ];

  cargoBuildFlags = [ "--bin httplz" ];
  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "0cy23smal6y5qj6a202zf7l76vwkpzvcjmlbq0ffyph3gq07ps7b";

  meta = with stdenv.lib; {
    description = "A basic http server for hosting a folder fast and simply";
    homepage = https://github.com/thecoshman/http;
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
  };
}
