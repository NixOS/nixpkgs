{ lib, stdenv, fetchurl, writeText, unzip, nixosTests }:

stdenv.mkDerivation rec {
  pname = "invoiceplane";
  version = "1.5.11";

  src = fetchurl {
    url = "https://github.com/InvoicePlane/InvoicePlane/releases/download/v${version}/v${version}.zip";
    sha256 = "137g0xps4kb3j7f5gz84ql18iggbya6d9dnrfp05g2qcbbp8kqad";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/
    cp -r . $out/
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
