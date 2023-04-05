{ lib
, bzip2
, patchelf
, python3
, gnutar
, unzip
}:

python3.pkgs.buildPythonApplication rec {
  pname = "auditwheel";
  version = "5.1.2";
  format = "setuptools";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-PuWDABSTHqhK9c0GXGN7ZhTvoD2biL2Pv8kk5+0B1ro=";
  };

  nativeBuildInputs = with python3.pkgs; [
    pbr
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pyelftools
    setuptools
  ];

  nativeCheckInputs = with python3.pkgs; [
    pretend
    pytestCheckHook
  ];

  # Integration tests require docker and networking
  disabledTestPaths = [
    "tests/integration"
  ];

  # Ensure that there are no undeclared deps
  postCheck = ''
    PATH= PYTHONPATH= $out/bin/auditwheel --version > /dev/null
  '';

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ bzip2 gnutar patchelf unzip ])
  ];

  meta = with lib; {
    description = "Auditing and relabeling cross-distribution Linux wheels";
    homepage = "https://github.com/pypa/auditwheel";
    license = with licenses; [
      mit  # auditwheel and nibabel
      bsd2  # from https://github.com/matthew-brett/delocate
      bsd3  # from https://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-projects/pax-utils/lddtree.py
    ];
    maintainers = with maintainers; [ davhau ];
    platforms = platforms.linux;
  };
}
