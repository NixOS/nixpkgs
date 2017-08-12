{ stdenv, fetchFromGitLab, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "mailman-${version}";
  version = "3.0.3";

  src = fetchFromGitLab {
    owner = "mailman";
    repo = "mailman";
    rev = "cdd24f88bd36aa2bd87252618e98b80aa7cc1bf1";
    sha256 = "0rkcv8wp52vbb8xxcf2166pjl175shv86cjii6kh32ysvplbi0qw";
  };

  postPatch = ''
    substituteInPlace src/mailman/commands/cli_control.py \
      --replace "config.BIN_DIR, 'master'" "config.BIN_DIR, '.master-wrapped'"
    substituteInPlace src/mailman/bin/master.py \
      --replace "config.BIN_DIR, 'runner'" "config.BIN_DIR, '.runner-wrapped'"
  '';

  propagatedBuildInputs = with python3Packages; [
    aiosmtpd alembic atpublic falcon flufl-bounce flufl-i18n flufl-lock flufl-testing
    httplib2 lazr-config lazr-smtptest nose nose2 passlib psycopg2 requests2 zope_component
  ];

  makeFlags = [ "DIRSETGID=:" ];

  meta = {
    homepage = http://www.gnu.org/software/mailman/;
    description = "Free software for managing electronic mail discussion and e-newsletter lists";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.globin ];
  };
}
