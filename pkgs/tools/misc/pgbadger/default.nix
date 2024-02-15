{ buildPerlPackage, shortenPerlShebang, stdenv, lib, fetchFromGitHub, which, bzip2, PodMarkdown, JSONXS
, TextCSV_XS }:
buildPerlPackage rec {
  pname = "pgbadger";
  version = "12.2";
  src = fetchFromGitHub {
    owner = "darold";
    repo = "pgbadger";
    rev = "v${version}";
    hash = "sha256-IzfpDqzS5VcehkPsFxyn3kJsvXs8nLgJ3WT8ZCmIDxI=";
  };

  postPatch = ''
    patchShebangs ./pgbadger
  '';

  # pgbadger has too many `-Idir` flags on its shebang line on Darwin,
  # causing the build to fail when trying to generate the documentation.
  # Rewrite the -I flags in `use lib` form.
  preBuild = lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang ./pgbadger
  '';

  outputs = [ "out" ];

  PERL_MM_OPT = "INSTALL_BASE=${placeholder "out"}";

  buildInputs = [ PodMarkdown JSONXS TextCSV_XS ];
  nativeBuildInputs = lib.optionals stdenv.isDarwin [ shortenPerlShebang ];

  nativeCheckInputs = [ which bzip2 ];

  meta = {
    homepage = "https://github.com/darold/pgbadger";
    description = "A fast PostgreSQL Log Analyzer";
    changelog = "https://github.com/darold/pgbadger/raw/v${version}/ChangeLog";
    license = lib.licenses.postgresql;
    maintainers = lib.teams.determinatesystems.members;
    mainProgram = "pgbadger";
  };
}
