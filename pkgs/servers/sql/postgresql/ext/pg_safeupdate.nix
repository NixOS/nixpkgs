{ lib, stdenv, fetchFromGitHub, postgresql }:

with {
  "12" = {
    version = "1.4";
    sha256 = "sha256-1cyvVEC9MQGMr7Tg6EUbsVBrMc8ahdFS3+CmDkmAq4Y=";
  };
  "13" = {
    version = "1.4";
    sha256 = "sha256-1cyvVEC9MQGMr7Tg6EUbsVBrMc8ahdFS3+CmDkmAq4Y=";
  };
  "14" = {
    version = "1.5";
    sha256 = "sha256-RRSpkWLFuif+6RCncnsb1NnjKnIIRY9KgebKkjCN5cs=";
  };
  "15" = {
    version = "1.5";
    sha256 = "sha256-RRSpkWLFuif+6RCncnsb1NnjKnIIRY9KgebKkjCN5cs=";
  };
  "16" = {
    version = "1.5";
    sha256 = "sha256-RRSpkWLFuif+6RCncnsb1NnjKnIIRY9KgebKkjCN5cs=";
  };
}."${lib.versions.major postgresql.version}" or (throw "pg_safeupdate: version specification for pg ${postgresql.version} missing.");

stdenv.mkDerivation rec {
  pname = "pg-safeupdate";
  inherit version;

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "eradman";
    repo   = pname;
    rev    = version;
    inherit sha256;
  };

  installPhase = ''
    install -D safeupdate${postgresql.dlSuffix} -t $out/lib
  '';

  meta = with lib; {
    description = "A simple extension to PostgreSQL that requires criteria for UPDATE and DELETE";
    homepage    = "https://github.com/eradman/pg-safeupdate";
    changelog   = "https://github.com/eradman/pg-safeupdate/raw/${src.rev}/NEWS";
    platforms   = postgresql.meta.platforms;
    maintainers = with maintainers; [ wolfgangwalther ];
    license     = licenses.postgresql;
  };
}
