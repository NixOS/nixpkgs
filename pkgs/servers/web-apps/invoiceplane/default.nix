{ lib, stdenv, fetchurl, writeText, unzip, nixosTests, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "invoiceplane";
  version = "1.6-beta-3";

  src = fetchurl {
    url = "https://github.com/InvoicePlane/InvoicePlane/releases/download/v${version}/v${version}.zip";
    sha256 = "sha256-sw5LaU3v4MIdX99WGKOaerVc9m3d8aQVuvrLn7KvcKE=";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/
    cp -r ip/. $out/
  '';

  passthru.tests = {
    inherit (nixosTests) invoiceplane;
  };

  meta = with lib; {
    description = "Self-hosted open source application for managing your invoices, clients and payments";
    license = licenses.mit;
    homepage = "https://www.invoiceplane.com";
    platforms = platforms.all;
    maintainers = with maintainers; [ onny ];
  };
}
