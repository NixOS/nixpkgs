{ lib, stdenv, fetchCrate, rustPlatform, openssl, pkg-config, Security }:

rustPlatform.buildRustPackage rec {
  pname = "apkeep";
  version = "0.9.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ST1ifON25mizKZQX3fKeqBloXWW9LXDq5JkZIeiguRY=";
  };

  cargoSha256 = "sha256-/Xh1s4PO336B1ioKe0IKVGDACpMuXOpxA82U6zn2lj0=";

  prePatch = ''
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A command-line tool for downloading APK files from various sources";
    homepage = "https://github.com/EFForg/apkeep";
    license = licenses.mit;
    maintainers = with maintainers; [ jyooru ];
  };
}
