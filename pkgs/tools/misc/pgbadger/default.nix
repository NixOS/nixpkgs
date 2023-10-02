{ buildPerlPackage, stdenv, lib, fetchFromGitHub, which, bzip2, PodMarkdown, JSONXS
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

  outputs = [ "out" ];

  PERL_MM_OPT = "INSTALL_BASE=${placeholder "out"}";

  buildInputs = [ PodMarkdown JSONXS TextCSV_XS ];

  nativeCheckInputs = [ which bzip2 ];

  meta = {
    homepage = "https://github.com/darold/pgbadger";
    description = "A fast PostgreSQL Log Analyzer";
    changelog = "https://github.com/darold/pgbadger/raw/v${version}/ChangeLog";
    license = lib.licenses.postgresql;
    maintainers = lib.teams.determinatesystems.members;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/pgbadger.x86_64-darwin
  };
}
