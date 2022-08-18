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
  version = "8.2.0";

  src = fetchFromGitHub {
    owner = "Edu4rdSHL";
    repo = pname;
    rev = version;
    sha256 = "sha256-VT4iPm6CbuKw9D53eSvunRC4Yvn94D5J95JJyq1Za9M=";
  };

  cargoSha256 = "sha256-gwBsIFhMHTISlKXCBqhzYhq0p5yX0OE0/zcU1yTOADQ=";

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
