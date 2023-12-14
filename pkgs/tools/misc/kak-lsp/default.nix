{ stdenv, lib, fetchFromGitHub, rustPlatform, perl, CoreServices, Security, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "kak-lsp";
  version = "15.0.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DpWYZa6Oe+Lkzga7Fol/8bTujb58wTFDpNJTaDEWBx8=";
  };

  cargoHash = "sha256-+3cpAL+8X8L833kmZapUoGSwHOj+hnDN6oDNJZ6y24Q=";

  buildInputs = [ perl ] ++ lib.optionals stdenv.isDarwin [ CoreServices Security SystemConfiguration ];

  patches = [ ./0001-Use-full-Perl-path.patch ];

  postPatch = ''
    substituteInPlace rc/lsp.kak \
      --subst-var-by perlPath ${lib.getBin perl}
  '';

  meta = with lib; {
    description = "Kakoune Language Server Protocol Client";
    homepage = "https://github.com/kak-lsp/kak-lsp";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = with maintainers; [ spacekookie poweredbypie ];
    mainProgram = "kak-lsp";
  };
}
