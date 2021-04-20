{ stdenv, fetchFromGitHub, postgresql }:
stdenv.mkDerivation {
  pname = "pgsidekick";
  version = "unstable-2014-11-23";
  src = fetchFromGitHub {
    owner = "wttw";
    repo = "pgsidekick";
    rev = "7d8612e0acba5d30aa1c650081e94e3b1a3aa76b";
    sha256 = "0mdalcp7kshky17jfca25c1377z4vg06191gz33ap0j2bwdb9kwv";
  };
  buildInputs = [ postgresql ];
  installPhase = ''
    mkdir -p $out/bin
    cp pglisten pglater $out/bin
  '';

  meta = with lib; {
    description = "Two PostgreSQL utility programs: pglisten and pglater.";
    longDescription = ''
      This is a small collection of programs that allow a postgresql database to trigger
      actions outside the database and to schedule commands to be run in the future,
      without installing any extensions into the database itself.
    '';
    homepage = https://github.com/wttw/pgsidekick;
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ ggpeti ];
  };
}
