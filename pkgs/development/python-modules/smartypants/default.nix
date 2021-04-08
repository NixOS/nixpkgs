{ stdenv
, buildPythonPackage
, fetchFromGitHub
, isPyPy
}:

buildPythonPackage rec {
  version = "1.8.6";
  pname = "smartypants";
  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "leohemsted";
    repo = "smartypants.py";
    rev = "v${version}";
    sha256 = "1cmzz44d2hm6y8jj2xcq1wfr26760gi7iq92ha8xbhb1axzd7nq6";
    # remove this file and the name on the next version update
    extraPostFetch = ''
      cp ${./hgtags} "$out"/.hgtags
    '';
    name = "hg-archive";
  };

  meta = with stdenv.lib; {
    description = "Python with the SmartyPants";
    homepage = "https://github.com/leohemsted/smartypants.py";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };

}
