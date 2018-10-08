{ stdenv
, buildPythonPackage
, fetchPypi
, six
, traceback2
}:

buildPythonPackage rec {
  version = "1.1.0";
  pname = "unittest2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "22882a0e418c284e1f718a822b3b022944d53d2d908e1690b319a9d3eb2c0579";
  };

  # # 1.0.0 and up create a circle dependency with traceback2/pbr
  doCheck = false;

  postPatch = ''
    # argparse is needed for python < 2.7, which we do not support anymore.
    substituteInPlace setup.py --replace "argparse" ""

    # # fixes a transient error when collecting tests, see https://bugs.launchpad.net/python-neutronclient/+bug/1508547
    sed -i '510i\        return None, False' unittest2/loader.py
    # https://github.com/pypa/packaging/pull/36
    sed -i 's/version=VERSION/version=str(VERSION)/' setup.py
  '';

  propagatedBuildInputs = [ six traceback2 ];

  meta = {
    description = "A backport of the new features added to the unittest testing framework";
    homepage = https://pypi.python.org/pypi/unittest2;
  };
}
