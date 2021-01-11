{ lib, stdenv, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "4.0.2";
  pname = "oxipng";

  src = fetchCrate {
    inherit version pname;
    sha256 = "0m36af9w1l6pc71fjbgyzcsszizwayvcv5d750zz2bnj23c77m69";
  };

  cargoSha256 = "16fby8ncdq0dyg9r0glrqwi04sja34br306c5sj22cq1dm3bb64q";

  doCheck = !stdenv.isAarch64 && !stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "A multithreaded lossless PNG compression optimizer";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
  };
}
