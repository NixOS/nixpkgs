{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "2.2.1";
  pname = "oxipng";

  src = fetchFromGitHub {
    owner = "shssoichiro";
    repo = pname;
    rev = "v${version}";
    sha256 = "1r195x3wdkshjwy23fpqsyyrw7iaj7yb39nhcnx9d4nhgq8w0pcl";
  };

  cargoSha256 = "08mw937s61r4fj9bqrg492ss13zkik9557n9yk90r97a81972zbn";

  # https://crates.io/crates/cloudflare-zlib#arm-vs-nightly-rust
  cargoBuildFlags = [ "--features=cloudflare-zlib/arm-always" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/shssoichiro/oxipng;
    description = "A multithreaded lossless PNG compression optimizer";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
  };
}
