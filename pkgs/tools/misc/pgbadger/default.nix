{
  buildPerlPackage,
  bzip2,
  fetchFromGitHub,
  JSONXS,
  lib,
  nix-update-script,
  pgbadger,
  PodMarkdown,
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
    tag = "v${version}";
    hash = "sha256-an/BOkQsMkTXS0HywV1JWerS16HRbO1MHVleYhVqmBM=";
  };

  postPatch = ''
    patchShebangs ./pgbadger
  '';

  outputs = [ "out" ];

  env.PERL_MM_OPT = "INSTALL_BASE=${placeholder "out"}";

  buildInputs = [
    JSONXS
    PodMarkdown
    TextCSV_XS
  ];

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
    mainProgram = "pgbadger";
  };
}
