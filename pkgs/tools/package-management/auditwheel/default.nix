{ lib
, buildPythonApplication
, fetchPypi
, patchelf
, pbr
, pretend
, pyelftools
, pytestCheckHook
, pythonOlder
}:

buildPythonApplication rec {
  pname = "auditwheel";
  version = "4.0.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03a079fe273f42336acdb5953ff5ce7578f93ca6a832b16c835fe337a1e2bd4a";
  };

  nativeBuildInputs = [
    pbr
  ];

  propagatedBuildInputs = [
    pyelftools
  ];

  # integration tests require docker and networking
  disabledTestPaths = [ "tests/integration" ];

  checkInputs = [
    pretend
    pytestCheckHook
  ];

  makeWrapperArgs = [
    ''--prefix PATH : ${patchelf}/bin''
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
