{ lib, buildPythonPackage, fetchPypi, fetchpatch, isPy3k, alembic, aiosmtpd, dnspython
, flufl_bounce, flufl_i18n, flufl_lock, lazr_config, lazr_delegates, passlib
, requests, zope_configuration, click, falcon, importlib-resources
, zope_component, lynx, postfix, authheaders, gunicorn
, docutils, sphinx
}:

buildPythonPackage rec {
  pname = "mailman";
  version = "3.3.4";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "01rx322b8mzcdj9xh4bjwnl0zis6n2wxd31rrij4cw3a2j03xpas";
  };

  propagatedBuildInputs = [
    alembic aiosmtpd click dnspython falcon flufl_bounce flufl_i18n flufl_lock
    importlib-resources lazr_config passlib requests zope_configuration
    zope_component authheaders gunicorn
  ];

  checkInputs = [ docutils sphinx ];

  patches = [
    (fetchpatch {
      url = https://gitlab.com/mailman/mailman/-/commit/4b206e2a5267a0e17f345fd7b2d957122ba57566.patch;
      sha256 = "06axmrn74p81wvcki36c7gfj5fp5q15zxz2yl3lrvijic7hbs4n2";
    })
    (fetchpatch {
      url = https://gitlab.com/mailman/mailman/-/commit/9613154f3c04fa2383fbf017031ef263c291418d.patch;
      sha256 = "0vyw87s857vfxbf7kihwb6w094xyxmxbi1bpdqi3ybjamjycp55r";
    })
    ./log-stderr.patch
  ];

  postPatch = ''
    substituteInPlace src/mailman/config/postfix.cfg \
      --replace /usr/sbin/postmap ${postfix}/bin/postmap
    substituteInPlace src/mailman/config/schema.cfg \
      --replace /usr/bin/lynx ${lynx}/bin/lynx
  '';

  # Mailman assumes that those scripts in $out/bin are Python scripts. Wrapping
  # them in shell code breaks this assumption. Use the wrapped version (see
  # wrapped.nix) if you need the CLI (rather than the Python library).
  #
  # This gives a properly wrapped 'mailman' command plus an interpreter that
  # has all the necessary search paths to execute unwrapped 'master' and
  # 'runner' scripts.
  dontWrapPythonPrograms = true;

  meta = {
    homepage = "https://www.gnu.org/software/mailman/";
    description = "Free software for managing electronic mail discussion and newsletter lists";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ peti qyliss ];
  };
}
