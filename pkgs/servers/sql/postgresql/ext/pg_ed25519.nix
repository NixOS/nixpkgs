{ stdenv, fetchurl, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_ed25519";
  version = "0.2";

  src = fetchurl {
    url = "https://gitlab.com/dwagin/${pname}/-/archive/${version}/${pname}-${version}.tar.bz2";
    sha256 = "0q46pvk1vq5w3al6i3inzlw6w7za3n7p1gd4wfbbxzvzh7qnynda";
  };

  buildInputs = [ postgresql ];

  installPhase = ''
    mkdir -p $out/bin    # For buildEnv to setup proper symlinks. See #22653
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with stdenv.lib; {
    description = "PostgreSQL extension for signing and verifying ed25519 signatures";
    homepage = "https://gitlab.com/dwagin/pg_ed25519";
    maintainers = [ maintainers.renzo ];
    platforms = postgresql.meta.platforms;
    license = licenses.mit;
  };
}

