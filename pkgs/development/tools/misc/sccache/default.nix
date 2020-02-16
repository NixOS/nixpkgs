{ stdenv, fetchFromGitHub, cargo, rustc, rustPlatform, pkgconfig, glib, openssl, darwin }:

rustPlatform.buildRustPackage rec {
  version = "0.2.12";
  pname = "sccache";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "sccache";
    rev = version;
    sha256 = "1yd3rfp032crwlmfn2p3z12f67q7bxm78fhvdlc7azm2a4hkif4k";
  };
  cargoSha256 = "17i3m7hj7kvdbicabmz2wl3g6s6c8lcyi3pririkq77jxm87shfh";

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
