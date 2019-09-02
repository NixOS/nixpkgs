{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "2.2.2";
  pname = "oxipng";

  src = fetchFromGitHub {
    owner = "shssoichiro";
    repo = pname;
    rev = "v${version}";
    sha256 = "07amczmyqs09zfp564nk8jy1n65y8pvk89qq6jv5k8npai8zvixn";
  };

  cargoSha256 = "1fkghjzsyg27n6k2yki0yhbdmmb1whgy5fjpydpjm4yv448nhhbm";

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
