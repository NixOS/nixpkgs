{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "2.3.0";
  pname = "oxipng";

  src = fetchFromGitHub {
    owner = "shssoichiro";
    repo = pname;
    rev = "v${version}";
    sha256 = "1cx026g1gdvk4qmnrbsmg46y2lizx0wqny25hhdjnh9pwzjc77mh";
  };

  cargoSha256 = "17wgsj2fcxhpsib3ps20sninbf236f9ihf4lnnfrawknmqfvq4s9";

  # https://crates.io/crates/cloudflare-zlib#arm-vs-nightly-rust
  cargoBuildFlags = [ "--features=cloudflare-zlib/arm-always" ];

  doCheck = !stdenv.isAarch64 && !stdenv.isDarwin;

  meta = with stdenv.lib; {
    homepage = https://github.com/shssoichiro/oxipng;
    description = "A multithreaded lossless PNG compression optimizer";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
  };
}
