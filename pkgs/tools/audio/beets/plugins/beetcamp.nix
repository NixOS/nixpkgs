{ lib,
  fetchFromGitHub,
  python3Packages,
  beets,

  propagateBeets ? false
}:

python3Packages.buildPythonApplication {
  pname = "beets-beetcamp";
  version = "unstable-2022-06-07";

  src = fetchFromGitHub {
    repo = "beetcamp";
    owner = "snejus";
    rev = "118d4239bd570a59997f13ac0920e6e92890ac67";
    sha256 = "sha256-yrlpgLdNEzlWMY7Cns0UE93oEbpkOoYZHGLpui6MfC0=";
  };

  format = "pyproject";

  propagatedBuildInputs = with python3Packages; [ setuptools poetry requests cached-property pycountry dateutil ordered-set ]
                                                ++ (lib.optional propagateBeets [ beets ]);

  checkInputs = with python3Packages; [
    # pytestCheckHook
    pytest-cov
    pytest-randomly
    pytest-lazy-fixture
    rich
    tox
    types-setuptools
    types-requests
  ] ++ [
    beets
  ];

  meta = {
    homepage = "https://github.com/snejus/beetcamp";
    description = "Bandcamp autotagger plugin for beets.";
    license = lib.licenses.gpl2;
    inherit (beets.meta) platforms;
    maintainers = with lib.maintainers; [ rrix ];
  };
}
