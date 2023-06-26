{ fetchFromGitHub, lib, rustPlatform, pkg-config, openssl, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "vrc-get";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "anatawa12";
    repo = pname;
    rev = "v${version}";
    sha256 = "16r3b2w4xfw1lwxp8ib23f76i4zgl8hk7q2g82yw6hxjimq69sy2";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  # Make openssl-sys use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  cargoSha256 = "1f76y7hzh4pk7gj0w5gqb65w8qvkfx1bxx9z3w9vdqdkz39439rf";

  meta = with lib; {
    description = "Command line client of VRChat Package Manager, the main feature of VRChat Creator Companion (VCC)";
    homepage = "https://github.com/anatawa12/vrc-get";
    license = licenses.mit;
    maintainers = with maintainers; [ bddvlpr ];
  };
}
