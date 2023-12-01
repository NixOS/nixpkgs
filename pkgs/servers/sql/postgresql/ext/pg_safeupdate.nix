{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg-safeupdate";
  version = "1.5";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "eradman";
    repo   = pname;
    rev    = version;
    sha256 = "sha256-RRSpkWLFuif+6RCncnsb1NnjKnIIRY9KgebKkjCN5cs=";
  };

  installPhase = ''
    install -D safeupdate${postgresql.dlSuffix} -t $out/lib
  '';

  meta = with lib; {
    description = "A simple extension to PostgreSQL that requires criteria for UPDATE and DELETE";
    homepage    = "https://github.com/eradman/pg-safeupdate";
    changelog   = "https://github.com/eradman/pg-safeupdate/raw/${src.rev}/NEWS";
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
    broken      = versionOlder postgresql.version "14";
  };
}
