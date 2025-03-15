{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  Security,
  testers,
  mdbook-linkcheck,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-linkcheck";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "Michael-F-Bryan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZbraChBHuKAcUA62EVHZ1RygIotNEEGv24nhSPAEj00=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit pname version src;
    hash = "sha256-mux0Rp+ffkVycWFC+dOHGZ3M784yO3rY7kypxwsVtr0=";
  };

  buildInputs = if stdenv.hostPlatform.isDarwin then [ Security ] else [ openssl ];

  nativeBuildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ pkg-config ];

  OPENSSL_NO_VENDOR = 1;

  doCheck = false; # tries to access network to test broken web link functionality

  passthru.tests.version = testers.testVersion { package = mdbook-linkcheck; };

  meta = with lib; {
    description = "Backend for `mdbook` which will check your links for you";
    mainProgram = "mdbook-linkcheck";
    homepage = "https://github.com/Michael-F-Bryan/mdbook-linkcheck";
    license = licenses.mit;
    maintainers = with maintainers; [
      zhaofengli
      matthiasbeyer
    ];
  };
}
