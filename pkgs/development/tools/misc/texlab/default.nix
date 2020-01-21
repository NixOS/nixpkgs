{ stdenv
, rustPlatform
, fetchFromGitHub
, nodejs
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "texlab";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "latex-lsp";
    repo = pname;
    # 1.9.0 + patches for building citeproc-db, see https://github.com/latex-lsp/texlab/pull/137
    rev = "e38fe4bedc9d8094649a9d2753ca9855e0c18882";
    sha256 = "0j87gmzyqrpgxrgalvlfqj5cj8j0h23hbbv8vdz2dhc847xhhfq1";
  };

  cargoSha256 = "09d9r7aal1q00idv08zdw7dygyasyp5l6jrh96cdclf63h1p4fk9";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "An implementation of the Language Server Protocol for LaTeX";
    homepage = https://texlab.netlify.com/;
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar metadark ];
    platforms = platforms.all;
  };
}
