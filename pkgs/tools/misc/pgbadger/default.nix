{
  buildPerlPackage,
  bzip2,
  fetchFromGitHub,
  JSONXS,
  lib,
  nix-update-script,
  pgbadger,
  PodMarkdown,
  shortenPerlShebang,
  stdenv,
  testers,
  TextCSV_XS,
  which,
}:

buildPerlPackage rec {
  pname = "pgbadger";
  version = "12.4";

  src = fetchFromGitHub {
    owner = "darold";
    repo = "pgbadger";
    rev = "refs/tags/v${version}";
    hash = "sha256-an/BOkQsMkTXS0HywV1JWerS16HRbO1MHVleYhVqmBM=";
  };

  postPatch = ''
    patchShebangs ./pgbadger
  '';

  # pgbadger has too many `-Idir` flags on its shebang line on Darwin,
  # causing the build to fail when trying to generate the documentation.
  # Rewrite the -I flags in `use lib` form.
  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    shortenPerlShebang ./pgbadger
  '';

  outputs = [ "out" ];

  PERL_MM_OPT = "INSTALL_BASE=${placeholder "out"}";

  buildInputs = [
    JSONXS
    PodMarkdown
    TextCSV_XS
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ shortenPerlShebang ];

  nativeCheckInputs = [
    bzip2
    which
  ];

  passthru = {
    tests.version = testers.testVersion {
      inherit version;
      command = "${lib.getExe pgbadger} --version";
      package = pgbadger;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/darold/pgbadger";
    description = "Fast PostgreSQL Log Analyzer";
    changelog = "https://github.com/darold/pgbadger/raw/v${version}/ChangeLog";
    license = lib.licenses.postgresql;
    maintainers = lib.teams.determinatesystems.members;
    mainProgram = "pgbadger";
  };
}
