{ stdenv, lib, fetchFromGitHub, rustPlatform, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  version = "0.3.0";
  pname = "sccache";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "sccache";
    rev = "v${version}";
    sha256 = "sha256-z4pLtSx1mg53AHPhT8P7BOEMCWHsieoS3rI0kEyJBcY=";
  };

  cargoSha256 = "sha256-4YF1fqthnWY6eu6J4SMwFG655KXdFCXmA9wxLyOOAw4=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  # sccache-dist is only supported on x86_64 Linux machines.
  buildFeatures = lib.optionals (stdenv.system == "x86_64-linux") [ "dist-client" "dist-server" ];

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
