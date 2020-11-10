{ stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg-safeupdate";
  version = "1.2";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "eradman";
    repo   = pname;
    rev    = version;
    sha256 = "010m57jcv5v8pyfm1cqs3a306y750lvnvla9m5d98v5vdx3349jg";
  };

  installPhase = ''
    mkdir -p $out/bin # for buildEnv, see https://github.com/NixOS/nixpkgs/issues/22653
    install -D safeupdate.so -t $out/lib
  '';

  meta = with stdenv.lib; {
    description = "A simple extension to PostgreSQL that requires criteria for UPDATE and DELETE";
    homepage    = "https://github.com/eradman/pg-safeupdate";
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
