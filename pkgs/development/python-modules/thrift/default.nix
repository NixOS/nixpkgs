{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  six,
  python,
}:

buildPythonPackage rec {
  pname = "thrift";
  version = "0.20.0";
  pyproject = true;

  # Still uses distutils
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TdZi6t9riuvopBcpUnvWmt9s6qKoaBy+9k0Sc7Po/ro=";
  };

  preBuild = ''
    # Fix so distutils is available in build prosess.
    # Function setuptools/_distutils/util.py:byte_compile is used in build prosess
    # but setuptools distutils import trick/hack is not working in build prosses
    # and we get ModuleNotfoundError 'No module named 'distutils'
    # For more explanation see first attempt:
    # https://github.com/NixOS/nixpkgs/pull/328182
    DISTUTILS=$(mktemp -d)
    ln -s ${setuptools}/${python.sitePackages}/setuptools/_distutils "$DISTUTILS/distutils"
    PYTHONPATH="$PYTHONPATH:$DISTUTILS"
  '';

  build-system = [ setuptools ];

  dependencies = [ six ];

  # No tests. Breaks when not disabling.
  doCheck = false;

  pythonImportsCheck = [ "thrift" ];

  meta = with lib; {
    description = "Python bindings for the Apache Thrift RPC system";
    homepage = "https://thrift.apache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ hbunke ];
  };
}
