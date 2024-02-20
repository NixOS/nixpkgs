{ stdenv, lib, fetchFromGitHub, rustPlatform, perl, CoreServices, Security, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "kak-lsp";
  version = "16.0.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-d4Tc6iYp20uOKMd+T2LhWgXWZzvzq1E+VWqjhhiIiHE=";
  };

  cargoHash = "sha256-NCI7KeKjLaen66qqaSLWhYTSCtlyFwBSQ5J3L+df2CE=";

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
