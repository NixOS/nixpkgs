{ fetchFromGitHub, lib, rustPlatform, pkg-config, openssl, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "vrc-get";
  version = "v1.1.1";

  src = fetchFromGitHub {
    owner = "anatawa12";
    repo = pname;
    rev = version;
    sha256 = "16r3b2w4xfw1lwxp8ib23f76i4zgl8hk7q2g82yw6hxjimq69sy2";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  # Make openssl-sys use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  cargoSha256 = "0szwr8r1y7w82xfx24ffxwqa9gv8m35k30nycfn8vng54vba1rcy";

  meta = with lib; {
    description = "Open Source command line client of VRChat Package Manager, the main feature of VRChat Creator Companion (VCC), that supports Windows, Linux, and macOS.";
    homepage = "https://github.com/anatawa12/vrc-get";
    license = licenses.mit;
    maintainers = with maintainers; [ bddvlpr ];
  };
}
