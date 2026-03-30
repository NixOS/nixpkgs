{
  lib,
  python3,
  fetchPypi,
  fetchpatch,
  sassc,
  hyperkitty,
  postorius,
  nixosTests,
}:

with python3.pkgs;

buildPythonPackage rec {
  pname = "mailman_web";
  version = "0.0.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3wnduej6xMQzrjGhGXQznfJud/Uoy3BDduukRJeahL8=";
  };

  patches = [
    (fetchpatch {
      name = "django-5.2.patch";
      url = "https://gitlab.com/mailman/mailman-web/-/commit/bf3eae03ba6ed416ff58e63ea30dd4b95f310e46.patch";
      includes = [ "pyproject.toml" ];
      hash = "sha256-NcXFXYJe3ve4qAGzOVZv9hBx4MTwxRtIYp1GRD1g0qw=";
    })
  ];

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

  meta = {
    homepage = "https://gitlab.com/mailman/mailman-web";
    description = "Django project for Mailman 3 web interface";
    mainProgram = "mailman-web";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      qyliss
      m1cr0man
    ];
  };
}
