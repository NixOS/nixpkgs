{ lib, stdenv, fetchFromGitLab, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_ed25519";
  version = "0.2";
  src = fetchFromGitLab {
    owner = "dwagin";
    repo = "pg_ed25519";
    rev = version;
    sha256 = "16w3qx3wj81bzfhydl2pjhn8b1jak6h7ja9wq1kc626g0siggqi0";
  };

  buildInputs = [ postgresql ];

  installPhase = ''
    mkdir -p $out/bin    # For buildEnv to setup proper symlinks. See #22653
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "PostgreSQL extension for signing and verifying ed25519 signatures";
    homepage = "https://gitlab.com/dwagin/pg_ed25519";
    maintainers = [ maintainers.renzo ];
    platforms = postgresql.meta.platforms;
    license = licenses.mit;
  };
}

