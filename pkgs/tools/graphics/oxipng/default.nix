{ stdenv, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "4.0.0";
  pname = "oxipng";

  src = fetchCrate {
    inherit version pname;
    sha256 = "0p9h006l75ci324lbcx496732pb77srcd46g6dnfw3mcrg33cspc";
  };

  cargoSha256 = "1r2zw7p95abxqc31b5gswdyhm4msxsiml34dsh9x8zydhqnwy17j";

  doCheck = !stdenv.isAarch64 && !stdenv.isDarwin;

  meta = with stdenv.lib; {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "A multithreaded lossless PNG compression optimizer";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
  };
}
