{ lib, stdenv, fetchCrate, rustPlatform, openssl, pkg-config, Security }:

rustPlatform.buildRustPackage rec {
  pname = "apkeep";
  version = "0.10.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "14vm3b2gbmn9pil0aagwchn4kyvi9311id6qv4a376qfb6r1aybf";
  };

  cargoSha256 = "0i8wzc58ji317kjdw3ls1908z4bqlh1cgjph0fxsvs5i552qjkzp";

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
