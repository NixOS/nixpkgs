{ lib, stdenv, fetchFromGitHub, writeText, unzip, nixosTests, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "invoiceplane";
  version = "1.5.11";

  src = fetchFromGitHub {
    owner = "InvoicePlane";
    repo = "InvoicePlane";
    rev = "7402b3761614d2cdd09836022b195e247922d509";
    sha256 = "sha256-iiJ1BUjWYD33zzG1vpo2LJ/Tks+MT2x+cR1+PIik46U=";
  };

  nativeBuildInputs = [ unzip ];

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
    # Not yet working with php >= 8
    # https://github.com/InvoicePlane/InvoicePlane/issues/798
    broken = true;
  };
}
