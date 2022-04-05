{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
, perl
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "findomain";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "Edu4rdSHL";
    repo = pname;
    rev = version;
    sha256 = "sha256-NhsEXYEYoRZ/HlMS+MP/N+ZxB13DDZr5B8MY5dbONP0=";
  };

  cargoSha256 = "sha256-Y/DgAMWhTgHuhdbYxpsg7UxLF7hXNQEY1aoaUbKdDEM=";

  nativeBuildInputs = [ installShellFiles perl ];
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  postInstall = ''
    installManPage ${pname}.1
  '';

  meta = with lib; {
    description = "The fastest and cross-platform subdomain enumerator";
    homepage = "https://github.com/Edu4rdSHL/findomain";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
