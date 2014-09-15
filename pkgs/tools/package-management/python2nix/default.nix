{ stdenv, fetchFromGitHub, pythonPackages }:


pythonPackages.buildPythonPackage rec {
  name = "python2nix-dev";
 
  # TODO: change to upstream once https://github.com/proger/python2nix/pull/3 is merged
  src = fetchFromGitHub {
    owner = "iElectric";
    repo = "python2nix";
    rev = "734de5f680425c6298eff46481e5e717d6e141a9";
    sha256 = "09qpzml38rplbr7vhplhzy3iy5n9fd3ba5b9r9cp6d08sk5xidqf";
  };

  propagatedBuildInputs = with pythonPackages; [ requests pip setuptools ];

  meta = with stdenv.lib; {
    maintainers = [ maintainers.iElectric ];
    platforms = platforms.all;
  };
}
