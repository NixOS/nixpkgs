{ lib, stdenv, fetchCrate, rustPlatform, openssl, pkg-config, Security }:

rustPlatform.buildRustPackage rec {
  pname = "apkeep";
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "0anfp3nwsainx9sw4njcmkzczq1rmib3dyncwhcf7y3j9v978d3h";
  };

  cargoSha256 = "0npw8f8c0qcprcins0pc12c5w47kv8dd1nrzv4xyllr44vx488mc";

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
