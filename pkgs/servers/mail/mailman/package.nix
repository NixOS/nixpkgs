{ lib, fetchpatch, python3, postfix, lynx
}:

with python3.pkgs;

buildPythonPackage rec {
  pname = "mailman";
  version = "3.3.5";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12mgxs1ndhdjjkydx48b95na9k9h0disfqgrr6wxx7vda6dqvcwz";
  };

  propagatedBuildInputs = with python3.pkgs; [
    aiosmtpd
    alembic
    authheaders
    click
    dnspython
    falcon
    flufl_bounce
    flufl_i18n
    flufl_lock
    gunicorn
    importlib-resources
    lazr_config
    passlib
    requests
    sqlalchemy
    zope_component
    zope_configuration
  ];

  patches = [
    (fetchpatch {
      url = "https://gitlab.com/mailman/mailman/-/commit/4b206e2a5267a0e17f345fd7b2d957122ba57566.patch";
      sha256 = "06axmrn74p81wvcki36c7gfj5fp5q15zxz2yl3lrvijic7hbs4n2";
    })
    (fetchpatch {
      url = "https://gitlab.com/mailman/mailman/-/commit/9613154f3c04fa2383fbf017031ef263c291418d.patch";
      sha256 = "0vyw87s857vfxbf7kihwb6w094xyxmxbi1bpdqi3ybjamjycp55r";
    })
    ./log-stderr.patch
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "alembic>=1.6.2,<1.7" "alembic>=1.6.2"

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

  # requires flufl.testing, which the upstream has archived
  doCheck = false;

  meta = {
    homepage = "https://www.gnu.org/software/mailman/";
    description = "Free software for managing electronic mail discussion and newsletter lists";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ qyliss ma27 ];
  };
}
