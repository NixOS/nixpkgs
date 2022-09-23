{ lib, python3
, sassc, hyperkitty, postorius
}:

with python3.pkgs;

buildPythonPackage rec {
  pname = "mailman-web";
  version = "0.0.5";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9pvs/VATAsMcGNrj58b/LifysEPTNhrAP57sfp4nX6Q=";
  };

  postPatch = ''
    # Django is depended on transitively by hyperkitty and postorius,
    # and mailman_web has overly restrictive version bounds on it, so
    # let's remove it.
    sed -i '/^[[:space:]]*django/Id' setup.cfg

    # Upstream seems to mostly target installing on top of existing
    # distributions, and uses a path appropriate for that, but we are
    # a distribution, so use a state directory appropriate for a
    # distro package.
    substituteInPlace mailman_web/settings/base.py \
        --replace /opt/mailman/web /var/lib/mailman-web
  '';

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ hyperkitty postorius whoosh ];

  # Tries to check runtime configuration.
  doCheck = false;

  makeWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ sassc ]}"
  ];

  meta = with lib; {
    description = "Django project for Mailman 3 web interface";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ qyliss m1cr0man ];
  };
}
