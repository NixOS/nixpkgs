{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "yarsi";
  version = "0.1.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-jyiKB2VdCRUzLjD8XaFQOIkgI6gE8uM0ztx4vqd6SrM=";
  };

  cargoSha256 = "sha256-yr43w53SrdFR2LhYwt6lh4mdNV98vc8XEAFn2JUsfn8=";


  meta = with lib; {
    description = "Yet another rust system info fetch. ";
    homepage = "https://github.com/bytehunt/yarsi";
    license = licenses.mit;
    maintainers = with maintainers; [ mrtuxa ];
  };
}