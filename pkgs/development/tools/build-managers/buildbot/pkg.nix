{ stdenv, buildPythonPackage, fetchPypi, setuptools }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "buildbot-pkg";
  version = "0.9.15.post1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gsa5fi1gkwnz8dsrl2s5kzcfawnj3nl8g8h6z1winz627l9n8sh";
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
