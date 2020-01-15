{ stdenv, fetchFromGitHub, rustPlatform, pkgs, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "httplz";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "thecoshman";
    repo = "http";
    rev = "v${version}";
    sha256 = "0q9ng8vf01k65zmcm7bbkqyrkj5hs86zdxwrfj98f4xqxrm75rf6";
  };

  buildInputs = with pkgs; [ openssl pkgconfig ] ++ lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  cargoBuildFlags = [ "--bin httplz" ];
  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "18qr3sy4zj4lwbzrz98d82kwagfbzkmrxk5sxl7w9vhdzy2diskw";

  meta = with stdenv.lib; {
    description = "A basic http server for hosting a folder fast and simply";
    homepage = https://github.com/thecoshman/http;
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
  };
}
