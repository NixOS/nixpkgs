{ stdenv, fetchFromGitHub, rustPlatform, pkgs, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "httplz";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "thecoshman";
    repo = "http";
    rev = "v${version}";
    sha256 = "00w8sy0m92by6lby1zb8hh36dnsrvwyyl56p6p7a1mf3iiq84r1y";
  };

  buildInputs = with pkgs; [ openssl pkgconfig ] ++ lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  cargoBuildFlags = [ "--bin httplz" ];
  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "1axf15ma7fkbphjc6hjrbcj9rbd1x5i4kyz7fjrlqjgdsmvaqc93";

  meta = with stdenv.lib; {
    description = "A basic http server for hosting a folder fast and simply";
    homepage = https://github.com/thecoshman/http;
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
  };
}
