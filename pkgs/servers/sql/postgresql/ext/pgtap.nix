{ lib, stdenv, fetchFromGitHub, postgresql, perl, perlPackages, which }:

stdenv.mkDerivation rec {
  pname = "pgtap";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "theory";
    repo = "pgtap";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-RaafUnrMRbvyf2m2Z+tK6XxVXDGnaOkYkSMxIJLnf6A=";
=======
    sha256 = "sha256-lb0PRffwo6J5a6Hqw1ggvn0cW7gPZ02OEcLPi9ineI8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ postgresql perl perlPackages.TAPParserSourceHandlerpgTAP which ];

  installPhase = ''
    install -D {sql/pgtap--${version}.sql,pgtap.control} -t $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "A unit testing framework for PostgreSQL";
    longDescription = ''
      pgTAP is a unit testing framework for PostgreSQL written in PL/pgSQL and PL/SQL.
      It includes a comprehensive collection of TAP-emitting assertion functions,
      as well as the ability to integrate with other TAP-emitting test frameworks.
      It can also be used in the xUnit testing style.
    '';
    maintainers = with maintainers; [ willibutz ];
    homepage = "https://pgtap.org";
    inherit (postgresql.meta) platforms;
    license = licenses.mit;
  };
}
