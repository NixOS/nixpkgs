{ lib
, rustPlatform
, fetchFromGitHub
, gpgme
, libgpgerror
, libxcb
, python3
}:

rustPlatform.buildRustPackage rec {
  pname = "gpg-tui";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "gpg-tui";
    rev = "v${version}";
    sha256 = "1hg8a1vxrkl2737dhb46ikzhnfz87zf9pvs370l9j8h7zz1mcq66";
  };

  cargoSha256 = "00azv55r4ldpr6gfn77ny9rzm3yqlpimvgzx2cwkwnhgmfcq2l1j";

  nativeBuildInputs = [
    gpgme # for gpgme-config
    libgpgerror # for gpg-error-config
    python3
  ];

  buildInputs = [
    gpgme
    libgpgerror
    libxcb
  ];

  meta = with lib; {
    description = "Terminal user interface for GnuPG";
    homepage = "https://github.com/orhun/gpg-tui";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
