{ lib, stdenv, fetchFromGitHub, postgresql, gitUpdater }:

stdenv.mkDerivation rec {
  pname = "hypopg";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "HypoPG";
    repo = "hypopg";
    rev = version;
    hash = "sha256-88uKPSnITRZ2VkelI56jZ9GWazG/Rn39QlyHKJKSKMM=";
  };

  buildInputs = [ postgresql ];

  installPhase = ''
    install -D -t $out/lib *${postgresql.dlSuffix}
    install -D -t $out/share/postgresql/extension *.control
    install -D -t $out/share/postgresql/extension *.sql
  '';

  passthru = {
    updateScript = gitUpdater {
      ignoredVersions = "beta";
    };
  };

  meta = with lib; {
    description = "Hypothetical Indexes for PostgreSQL";
    homepage = "https://hypopg.readthedocs.io";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with maintainers; [ bbigras ];
  };
}
