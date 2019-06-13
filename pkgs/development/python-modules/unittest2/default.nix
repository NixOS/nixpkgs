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
    sha256 = "0y855kmx7a8rnf81d3lh5lyxai1908xjp0laf4glwa4c8472m212";
  };

  propagatedBuildInputs = [ six traceback2 ];

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

  meta = with stdenv.lib; {
    description = "A backport of the new features added to the unittest testing framework";
    homepage = https://pypi.python.org/pypi/unittest2;
    license = licenses.bsd0;
  };

}
