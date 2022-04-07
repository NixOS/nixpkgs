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
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "Edu4rdSHL";
    repo = pname;
    rev = version;
    sha256 = "sha256-Bk3p8+FkjrF/nLsPRx8daqieV8iewAbcoO2DglFSERg=";
  };

  cargoSha256 = "sha256-chHr/3yN2PLUQLYqkln12q3+n7tX2IclVGpXBCkPxCQ=";

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
