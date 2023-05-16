{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "plpgsql_check";
<<<<<<< HEAD
  version = "2.5.0";
=======
  version = "2.3.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "okbob";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-6S1YG/4KGlgtTBrxh3p6eMd/aCovK/QME4f2z0YTUxc=";
=======
    hash = "sha256-kXci/4o7rK1CiLp8alkAGMhxjiQBIPpavS/1/7BBWI8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ postgresql ];

  installPhase = ''
    install -D -t $out/lib *.so
    install -D -t $out/share/postgresql/extension *.sql
    install -D -t $out/share/postgresql/extension *.control
  '';

  meta = with lib; {
    description = "Linter tool for language PL/pgSQL";
    homepage = "https://github.com/okbob/plpgsql_check";
<<<<<<< HEAD
    changelog = "https://github.com/okbob/plpgsql_check/releases/tag/v${version}";
    platforms = postgresql.meta.platforms;
    license = licenses.mit;
    broken = versionOlder postgresql.version "12";
=======
    platforms = postgresql.meta.platforms;
    license = licenses.mit;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = [ maintainers.marsam ];
  };
}
