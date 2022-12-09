{ lib, stdenv, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "7.0.0";
  pname = "oxipng";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-egAt2XypPFxsOuo8RsIXTmFdmBUe+eZh3p3vlnnx8wo=";
  };

  cargoHash = "sha256-GbJU31UBdRai2JLEdx9sPh6rJWnU4RlDL8DooI9MCUg=";

  doCheck = !stdenv.isAarch64 && !stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "A multithreaded lossless PNG compression optimizer";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
  };
}
