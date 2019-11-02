{ stdenv, fetchFromGitHub, postgresql, perl, perlPackages, which }:

stdenv.mkDerivation rec {
  pname = "pgtap";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "theory";
    repo = "pgtap";
    rev = "v${version}";
    sha256 = "0ks53lsrpa8yxav8jh0jlvs25y6p7mkcdch8il1kvib9k5zq2wnb";
  };

  nativeBuildInputs = [ postgresql perl perlPackages.TAPParserSourceHandlerpgTAP which ];

  installPhase = ''
    install -D {sql/pgtap--${version}.sql,pgtap.control} -t $out/share/postgresql/extension
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
    license = licenses.mit;
  };
}
