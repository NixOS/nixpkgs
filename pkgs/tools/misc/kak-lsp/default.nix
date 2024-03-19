{ stdenv, lib, fetchFromGitHub, rustPlatform, perl, CoreServices, Security, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "kak-lsp";
  version = "15.0.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-W4z2YtOEBCTM+NsL1HBHSYCXJXN459chE4RW0CPMjD4=";
  };

  cargoHash = "sha256-tAA9eu4y1h6huNmEgY3L6v29itP5I4a8UZgoA+ANoq0=";

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
