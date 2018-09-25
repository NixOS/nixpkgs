{ stdenv, fetchFromGitHub, postgresql, perl, perlPackages, which }:

stdenv.mkDerivation rec {
  name = "pgtap-${version}";
  version = "0.99.0";

  src = fetchFromGitHub {
    owner = "theory";
    repo = "pgtap";
    rev = "v${version}";
    sha256 = "0xakjlbb99mgd8za6m0xa6n3s5fhif217iip6b3aywqw7nh1j6nv";
  };

  nativeBuildInputs = [ postgresql perl perlPackages.TAPParserSourceHandlerpgTAP which ];

  installPhase = ''
    install -D {sql/pgtap--${version}.sql,pgtap.control} -t $out/share/extension
  '';

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
