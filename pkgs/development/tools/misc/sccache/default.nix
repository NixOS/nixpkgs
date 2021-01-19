{ stdenv, fetchFromGitHub, cargo, rustc, rustPlatform, pkg-config, glib, openssl, darwin }:

rustPlatform.buildRustPackage rec {
  version = "0.2.14";
  pname = "sccache";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "sccache";
    rev = version;
    sha256 = "1ahg3cpb9pbgpdjglnfxm5c8r8qrgwaxwz5s394478ix7f9dxind";
  };
  cargoSha256 = "0jphs0frr399iywi9ch8g271igayzv1vi3wa4v3yx19xdxawlgda";

  cargoBuildFlags = [ "--features=all" ];
  nativeBuildInputs = [
    pkg-config cargo rustc
  ];
  buildInputs = [
    openssl
  ] ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;
  # Tests fail because of client server setup which is not possible inside the pure environment,
  # see https://github.com/mozilla/sccache/issues/460
  checkPhase = null;

  meta = with stdenv.lib; {
    description = "Ccache with Cloud Storage";
    homepage = "https://github.com/mozilla/sccache";
    maintainers = with maintainers; [ doronbehar ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
