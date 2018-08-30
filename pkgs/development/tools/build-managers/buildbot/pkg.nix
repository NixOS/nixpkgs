{ stdenv, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "buildbot-pkg";
  version = "1.2.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "70f429311c5812ffd334f023f4f50b904be5c672c8674ee6d28a11a7c096f18a";
  };

  propagatedBuildInputs = with python3Packages; [ setuptools ];

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
