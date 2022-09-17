{ lib, stdenv, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "6.0.1";
  pname = "oxipng";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-YH4sIEOTPBbzsEMvHyphOsf12ZZRKsRPMlZ4emMMTrw=";
  };

  cargoSha256 = "sha256-c7uEb64epjzU3pmHRr69FoxFGCN+1WVMLm8LsBwQ50o=";

  doCheck = !stdenv.isAarch64 && !stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "A multithreaded lossless PNG compression optimizer";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
  };
}
