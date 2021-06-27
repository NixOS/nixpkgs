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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "gpg-tui";
    rev = "v${version}";
    sha256 = "sha256-aKMO/T7jojlQGdtOqsEqTtnSBkVjyFuXmPxvFjVYl4Y=";
  };

  cargoSha256 = "sha256-hRpzW2kISPZ2lwun+nqTi8vIv+9j6r/0yI1TjtH+ltw=";

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
