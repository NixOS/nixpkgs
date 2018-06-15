{ stdenv, buildPythonPackage, fetchPypi, setuptools }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "buildbot-pkg";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f14453e2f2f357f44edd79df2d3b3901b4e03f4746693c209b71e226ed238cd";
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
