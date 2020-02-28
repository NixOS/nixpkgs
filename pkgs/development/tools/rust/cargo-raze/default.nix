{ stdenv, fetchFromGitHub, rustPlatform
, pkgconfig, curl, libgit2, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-raze";
  version = "0.2.15";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cbbf0r753h4m42h0z44yn99cbwkchacf703j2i9gdi7d60ns92p";
  };

  sourceRoot = "source/impl";

  cargoSha256 = "1d9ra80bilgmn44a4dzjvc4cyl9wv6bzkp8mavr6qjpjq57x4sin";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ curl libgit2 openssl ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Generate Bazel BUILD files from Cargo dependencies";
    homepage = "https://github.com/google/cargo-raze";
    license = licenses.asl20;
    maintainers = with maintainers; [ elasticdog ];
    platforms = platforms.all;
  };
}
