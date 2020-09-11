{ stdenv, fetchFromGitHub, rustPlatform, Security, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "jwt-cli";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "mike-engel";
    repo = pname;
    rev = version;
    sha256 = "0pmxis3m3madwnmswz9hn0i8fz6a9bg11slgrrwql7mx23ijqf6y";
  };

  cargoSha256 = "165g1v0c8jxs8ddm8ld0hh7k8mvk3566ig43pf99hnw009fg1yc2";

  patches = [
    # to fix `cargo test -- --test-threads $NIX_BUILD_CORES`
    (fetchpatch {
      url = "https://github.com/mike-engel/jwt-cli/commit/df87111f3084abdecce5d58ad031edb6e7fef94a.patch";
      sha256 = "1vjk7wy8ddkz9wjkiayag61gklrq59m7bwlaiyinjp4n15gx0j1k";
    })
  ];

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "Super fast CLI tool to decode and encode JWTs";
    homepage = "https://github.com/mike-engel/jwt-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ rycee ];
  };
}
