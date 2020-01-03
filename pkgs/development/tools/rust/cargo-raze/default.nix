{ stdenv, fetchFromGitHub, rustPlatform
, pkgconfig, curl, libgit2, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-raze";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fznh8jygzyzphw7762qc2jv0370z7qjqk1vkql0g246iqby8pq9";
  };
  sourceRoot = "source/impl";

  cargoSha256 = "06rl7v0f1lgj9ii07fcnaxmhn28ckr03cpf5b93q8ripm5qh7my9";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ curl libgit2 openssl ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Generate Bazel BUILD files from Cargo dependencies";
    homepage = https://github.com/google/cargo-raze;
    license = licenses.asl20;
    maintainers = with maintainers; [ elasticdog ];
    platforms = platforms.all;
  };
}
