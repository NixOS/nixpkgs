{
  lib,
  python3,
  fetchPypi,
  sassc,
  hyperkitty,
  postorius,
  nixosTests,
}:

with python3.pkgs;

buildPythonPackage rec {
  pname = "mailman_web";
  version = "0.0.9";
  disabled = pythonOlder "3.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3wnduej6xMQzrjGhGXQznfJud/Uoy3BDduukRJeahL8=";
  };

  postPatch = ''
    # Upstream seems to mostly target installing on top of existing
    # distributions, and uses a path appropriate for that, but we are
    # a distribution, so use a state directory appropriate for a
    # distro package.
    substituteInPlace mailman_web/settings/base.py \
        --replace-fail /opt/mailman/web /var/lib/mailman-web
  '';

  nativeBuildInputs = [ pdm-backend ];
  propagatedBuildInputs = [
    hyperkitty
    postorius
    whoosh
  ];

  # Tries to check runtime configuration.
  doCheck = false;

  makeWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ sassc ]}"
  ];

  passthru.tests = { inherit (nixosTests) mailman; };

  meta = with lib; {
    homepage = "https://gitlab.com/mailman/mailman-web";
    description = "Django project for Mailman 3 web interface";
    mainProgram = "mailman-web";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      qyliss
      m1cr0man
    ];
  };
}
