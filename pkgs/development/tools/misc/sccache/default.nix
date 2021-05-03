{ stdenv, lib, fetchFromGitHub, rustPlatform, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  version = "0.2.15";
  pname = "sccache";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "sccache";
    rev = "v${version}";
    sha256 = "1kygk7ilv7la36kv4jdn1ird7f3896wgr88kyqf0iagfqkzb2vsb";
  };

  cargoSha256 = "1cfdwf00jgwsv0f72427asid1xr57s56jk5xj489dgppvgy7wdbj";

  cargoBuildFlags = lib.optionals (!stdenv.isDarwin) [ "--features=dist-client,dist-server" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  # Tests fail because of client server setup which is not possible inside the pure environment,
  # see https://github.com/mozilla/sccache/issues/460
  doCheck = false;

  meta = with lib; {
    description = "Ccache with Cloud Storage";
    homepage = "https://github.com/mozilla/sccache";
    maintainers = with maintainers; [ doronbehar ];
    license = licenses.asl20;
  };
}
