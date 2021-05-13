{ lib
, patchelf
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "auditwheel";
  version = "4.0.0";

  disabled = python3.pkgs.pythonOlder "3.6";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "03a079fe273f42336acdb5953ff5ce7578f93ca6a832b16c835fe337a1e2bd4a";
  };

  nativeBuildInputs = with python3.pkgs; [
    pbr
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pyelftools
  ];

  # integration tests require docker and networking
  disabledTestPaths = [ "tests/integration" ];

  checkInputs = with python3.pkgs; [
    pretend
    pytestCheckHook
  ];

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ patchelf ])
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
  };
}
