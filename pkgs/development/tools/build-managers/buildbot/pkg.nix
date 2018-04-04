{ stdenv, buildPythonPackage, fetchPypi, setuptools }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "buildbot-pkg";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2276c1e7e01908490bffcebd5502456fa34223e302853e744a79467de82ab219";
  };

  propagatedBuildInputs = [ setuptools ];

  postPatch = ''
    # Their listdir function filters out `node_modules` folders.
    # Do we have to care about that with Nix...?
    substituteInPlace buildbot_pkg.py --replace "os.listdir = listdir" ""
  '';

  meta = with stdenv.lib; {
    homepage = http://buildbot.net/;
    description = "Buildbot Packaging Helper";
    maintainers = with maintainers; [ nand0p ryansydnor ];
    license = licenses.gpl2;
  };
}
