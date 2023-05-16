{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_cron";
<<<<<<< HEAD
  version = "1.6.0";
=======
  version = "1.5.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = pname;
    rev    = "v${version}";
<<<<<<< HEAD
    hash   = "sha256-s1wjBx84Z12fRlaT1y3CPEFHK8tzMKp7wF+t7suRNL4=";
=======
    hash   = "sha256-+quVWbKJy6wXpL/zwTk5FF7sYwHA7I97WhWmPO/HSZ4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "Run Cron jobs through PostgreSQL";
    homepage    = "https://github.com/citusdata/pg_cron";
    changelog   = "https://github.com/citusdata/pg_cron/raw/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
