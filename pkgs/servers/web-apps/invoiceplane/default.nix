{ lib, stdenv, fetchurl, writeText, unzip, nixosTests, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "invoiceplane";
  version = "1.5.11";

  src = fetchurl {
    url = "https://github.com/InvoicePlane/InvoicePlane/releases/download/v${version}/v${version}.zip";
    sha256 = "137g0xps4kb3j7f5gz84ql18iggbya6d9dnrfp05g2qcbbp8kqad";
  };

  patches = [

    # Fix CVE-2021-29024, unauthenticated directory listing
    # Should be included in a later release > 1.5.11
    # https://github.com/NixOS/nixpkgs/issues/166655
    # https://github.com/InvoicePlane/InvoicePlane/pull/754
    (fetchpatch {
      url = "https://github.com/InvoicePlane/InvoicePlane/commit/5db67d65ccaaec661885bd029b1e516bf3ca6c2a.patch";
      sha256 = "sha256-EHXw7Zqli/nA3tPIrhxpt8ueXvDtshz0XRzZT78sdQk=";
      name = "cve-2021-29024-fix.patch";
    })

    # Fix CVE-2021-29023, password reset rate-limiting
    # Should be included in a later release > 1.5.11
    # https://github.com/NixOS/nixpkgs/issues/166655
    # https://github.com/InvoicePlane/InvoicePlane/pull/767
    #(fetchpatch {
    #  url = "https://patch-diff.githubusercontent.com/raw/InvoicePlane/InvoicePlane/pull/767.patch";
    #  sha256 = "sha256-rSWDH8KeHSRWLyQEa7RSwv+8+ja9etTz+6Q9XThuwUo=";
    #  name = "cve-2021-29023-fix.patch";
    #})

    # Fix CVE-2021-29022, full path disclosure
    # Should be included in a later release > 1.5.11
    # https://github.com/NixOS/nixpkgs/issues/166655
    # https://github.com/InvoicePlane/InvoicePlane/pull/739
    (fetchpatch {
      url = "https://github.com/InvoicePlane/InvoicePlane/commit/694ba97d6e207bd4357ce4d2992601f0320f69fe.patch";
      sha256 = "sha256-6ksJjW6awr3lZsDRxa22pCcRGBVBYyV8+TbhOp6HBq0=";
      name = "cve-2021-29022-fix.patch"
    })

  ];

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
    description = ''
      Self-hosted open source application for managing your invoices, clients
      and payments
    '';
    license = licenses.mit;
    homepage = "https://www.invoiceplane.com";
    platforms = platforms.all;
    maintainers = with maintainers; [ onny ];
    # Not yet working with php >= 8
    # https://github.com/InvoicePlane/InvoicePlane/issues/798
    broken = true;
  };
}
