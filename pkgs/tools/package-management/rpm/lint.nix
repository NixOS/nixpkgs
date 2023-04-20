{ buildPythonPackage
, checkbashisms # Not in README
, cpio
, fetchFromGitHub
, fetchpatch
, lib
, pybeam
, pyenchant
, pytestCheckHook
, pytest-cov
, pytest-xdist
, python
, python-magic
, pyxdg
, rpm
, tomli
, tomli-w
, zstandard
}:

buildPythonPackage rec {
  pname = "rpmlint";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = pname;
    rev = version;
    hash = "sha256-NzPGIwbxZ7WyVGxdNTIaYbznvZ4WnFuVEgdwlgmJrx4=";
  };

  patches = [
    (fetchpatch {
      name = "drop pytest-flake8";
      url = "https://github.com/rpm-software-management/rpmlint/pull/1054.patch";
      hash = "sha256-Pa6wnW+JFYaVqZwZ756dvd7idAU+5r0tZ4IXfmynR/Q=";
    })
  ];

  postPatch = ''
    substituteInPlace test/test_ldd_parser.py --replace 'def test_ldd_parser_failure():' '@pytest.mark.skipif(True, reason="Inside sandbox /bin/sh is busybox and does not support bash localized string")
    def test_ldd_parser_failure():'
  '';

  preBuild = ''
    substituteInPlace setup.py --replace "   'rpm'," ""
  '';

  buildInputs = [
    pybeam
    pyenchant
    python-magic
    pyxdg
    rpm
  ]
  ++ lib.optionals (lib.versionOlder python.version "3.11") [ tomli ]
  ++ [
    tomli-w
    zstandard
  ];

  nativeCheckInputs = [
    checkbashisms
    cpio
    pytestCheckHook
    pytest-cov
    pytest-xdist
    rpm
  ];

  meta = with lib; {
    # metadata from https://rpmfind.net/linux/RPM/fedora/devel/rawhide/x86_64/r/rpmlint-2.4.0-4.fc38.noarch.html
    description = "Tool for checking common errors in RPM packages";
    longDescription = ''
        rpmlint is a tool for checking common errors in RPM packages. Binary
        and source packages as well as spec files can be checked.
      '';
    homepage = "https://github.com/rpm-software-management/rpmlint";
    downloadPage = "https://github.com/rpm-software-management/rpmlint/releases";
    changelog = "https://github.com/rpm-software-management/rpmlint/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = [];
    mainProgram = "rpmlint"; # Most tutorials only explain this tools but it is used one time
    platforms = platforms.unix;
    sourceProvenance = with sourceTypes; [ fromSource ];
  };
}
