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

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    allowGitDependencies = false;
    hash = "sha256-Tt7ljjWv2CMtP/ELZNgSH/ifmBk/42+E0r9ZXQEJNP8=";
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
