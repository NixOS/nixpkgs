{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg-safeupdate";
  version = "1.4";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "eradman";
    repo   = pname;
    rev    = version;
    sha256 = "sha256-1cyvVEC9MQGMr7Tg6EUbsVBrMc8ahdFS3+CmDkmAq4Y=";
  };

  installPhase = ''
    mkdir -p $out/bin # for buildEnv, see https://github.com/NixOS/nixpkgs/issues/22653
    install -D safeupdate.so -t $out/lib
  '';

  meta = with lib; {
    description = "A simple extension to PostgreSQL that requires criteria for UPDATE and DELETE";
    homepage    = "https://github.com/eradman/pg-safeupdate";
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
