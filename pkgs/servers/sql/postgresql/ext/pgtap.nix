{ stdenv, fetchFromGitHub, postgresql, perl, perlPackages, which }:

stdenv.mkDerivation rec {
  name = "pgtap-${version}";
  version = "0.98.0";

  src = fetchFromGitHub {
    owner = "theory";
    repo = "pgtap";
    rev = "v${version}";
    sha256 = "17r3b409k05pbypmwdwgm1fl669jc6a1391szyxizx784k44a369";
  };

  nativeBuildInputs = [ postgresql perl perlPackages.TAPParserSourceHandlerpgTAP which ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "pgTAP is a unit testing framework for PostgreSQL";
    longDescription = ''
      pgTAP is a unit testing framework for PostgreSQL written in PL/pgSQL and PL/SQL.
      It includes a comprehensive collection of TAP-emitting assertion functions,
      as well as the ability to integrate with other TAP-emitting test frameworks.
      It can also be used in the xUnit testing style.
    '';
    maintainers = with maintainers; [ willibutz ];
    homepage = https://pgtap.org;
    inherit (postgresql.meta) platforms;
  };
}
