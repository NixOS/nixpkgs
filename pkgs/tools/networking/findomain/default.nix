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
  version = "8.1.1";

  src = fetchFromGitHub {
    owner = "Edu4rdSHL";
    repo = pname;
    rev = version;
    sha256 = "sha256-ngT9ZtPsCzcmZbwpmzbEcSUTHPezzdyAB12qrm5Z6n0=";
  };

  cargoSha256 = "sha256-nHNS1Uskggm5e1paWRSiL4HHcooDbYe0toMwR05OkDQ=";

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
