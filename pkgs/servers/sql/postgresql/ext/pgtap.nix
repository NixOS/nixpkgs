{ lib, stdenv, fetchFromGitHub, postgresql, perl, perlPackages, which }:

stdenv.mkDerivation rec {
  pname = "pgtap";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "theory";
    repo = "pgtap";
    rev = "v${version}";
    sha256 = "sha256-lb0PRffwo6J5a6Hqw1ggvn0cW7gPZ02OEcLPi9ineI8=";
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
