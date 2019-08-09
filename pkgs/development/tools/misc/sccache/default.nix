{ stdenv, fetchFromGitHub, cargo, rustc, rustPlatform, pkgconfig, glib, openssl, darwin }:

rustPlatform.buildRustPackage rec {
  version = "0.2.9";
  name = "sccache-${version}";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "sccache";
    rev = version;
    sha256 = "0glaaan6fh19a2d8grgsgnbgw5w53vjl0qmvvnq0ldp3hax90v46";
  };
  cargoSha256 = "0chfdyhj9lyxydbnmldc8rh2v9dda46sxhv35g34a5137sjrizfh";
  cargoBuildFlags = [ "--features=all" ];
  # see https://github.com/mozilla/sccache/issues/467
  postPatch = ''
    sed -i 's/\(version = "0.2.9\)-alpha.0"/\1"/g' Cargo.lock
  '';
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
