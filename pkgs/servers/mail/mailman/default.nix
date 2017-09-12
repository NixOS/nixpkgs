{ stdenv, fetchFromGitLab, python3 }:

python3.pkgs.buildPythonApplication rec {
  name = "mailman-${version}";
  version = "3.1.0";

  src = fetchFromGitLab {
    owner = "mailman";
    repo = "mailman";
    rev = version;
    sha256 = "1y38ajlvcq7lfz2cbdsr32f70qxizkwgski1fg4kv1p39sam47nq";
  };

  postPatch = ''
    substituteInPlace src/mailman/commands/cli_control.py \
      --replace "config.BIN_DIR, 'master'" "config.BIN_DIR, '.master-wrapped'"
    substituteInPlace src/mailman/bin/master.py \
      --replace "config.BIN_DIR, 'runner'" "config.BIN_DIR, '.runner-wrapped'"
  '';

  propagatedBuildInputs = with python3.pkgs; [
    aiosmtpd alembic atpublic falcon flufl-bounce flufl-i18n flufl-lock flufl-testing dns
    httplib2 lazr-config lazr-smtptest nose nose2 passlib psycopg2 requests zope_component
  ];

  # checkPhase = ''
  #   python -m nose2 -v
  # '';
  doCheck = false;

  makeFlags = [ "DIRSETGID=:" ];

  meta = {
    homepage = http://www.gnu.org/software/mailman/;
    description = "Free software for managing electronic mail discussion and e-newsletter lists";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.globin ];
  };
}
