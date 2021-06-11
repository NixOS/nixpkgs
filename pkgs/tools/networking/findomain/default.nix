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
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "Edu4rdSHL";
    repo = pname;
    rev = version;
    sha256 = "sha256-UC70XmhAVf2a2QO9bkIRE5vEsWyIA0DudZfKraNffGY=";
  };

  cargoSha256 = "sha256-Cdfh3smX6UjiG29L9hG22bOQQIjaNrv+okl153mIiso=";

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
