{ stdenv, fetchFromGitHub, cargo, rustc, rustPlatform, pkgconfig, glib, openssl, darwin }:

rustPlatform.buildRustPackage rec {
  version = "0.2.10";
  name = "sccache-${version}";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "sccache";
    rev = version;
    sha256 = "13fiifv3bi9shzp30wd7k2nd2j43vzdhk6z5rnfn5a9hmijqpg9n";
  };
  cargoSha256 = "1bkglgrasyjyzjj9mwm32d3g3mg5yv74jj3zl7jf20dlq3rg3fh6";

  cargoBuildFlags = [ "--features=all" ];
  nativeBuildInputs = [
    pkgconfig cargo rustc
  ];
  buildInputs = [
    openssl
  ] ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;
  # Tests fail because of client server setup which is not possible inside the pure environment,
  # see https://github.com/mozilla/sccache/issues/460
  checkPhase = null;

  meta = with stdenv.lib; {
    description = "Ccache with Cloud Storage";
    homepage = https://github.com/mozilla/sccache;
    maintainers = with maintainers; [ doronbehar ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
