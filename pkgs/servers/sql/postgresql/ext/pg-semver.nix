{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pg-semver";
  version = "0.40.0";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner = "theory";
    repo = "pg-semver";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-9f+QuGupjTUK3cQk7DFDrL7MOIwDE9SAUyVZ9RfrdDM=";
  };

  installPhase = ''
    install -D -t $out/lib src/semver${postgresql.dlSuffix}
    install -D semver.control -t $out/share/postgresql/extension
    install -D sql/* -t $out/share/postgresql/semver
  '';

  meta = with lib; {
    description = "Semantic version data type for PostgreSQL";
    homepage = "https://github.com/theory/pg-semver";
    changelog = "https://github.com/theory/pg-semver/blob/main/Changes";
    maintainers = with maintainers; [ grgi ];
    platforms = postgresql.meta.platforms;
    license = licenses.postgresql;
  };
})
