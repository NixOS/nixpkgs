{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "3.0.1";
  pname = "oxipng";

  src = fetchFromGitHub {
    owner = "shssoichiro";
    repo = pname;
    rev = "v${version}";
    sha256 = "11lncwxksm7aqczy9ay1qnba2wmgfsirhgrl6vv1jlgj41b7mzi5";
  };

  cargoSha256 = "0lalb981qzlnmqfg170mh6lnc0qlzb94wc39mf859g2jvxk3pkrl";

  # https://crates.io/crates/cloudflare-zlib#arm-vs-nightly-rust
  cargoBuildFlags = [ "--features=cloudflare-zlib/arm-always" ];

  doCheck = !stdenv.isAarch64 && !stdenv.isDarwin;

  meta = with stdenv.lib; {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "A multithreaded lossless PNG compression optimizer";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
  };
}
