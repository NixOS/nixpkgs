{ stdenv
, buildPythonPackage
, fetchhg
, isPyPy
}:

buildPythonPackage rec {
  version = "1.8.6";
  pname = "smartypants";
  disabled = isPyPy;

  src = fetchhg {
    url = "https://bitbucket.org/livibetter/smartypants.py";
    rev = "v${version}";
    sha256 = "1cmzz44d2hm6y8jj2xcq1wfr26760gi7iq92ha8xbhb1axzd7nq6";
  };

  meta = with stdenv.lib; {
    description = "Python with the SmartyPants";
    homepage = "https://bitbucket.org/livibetter/smartypants.py";
    license = licenses.bsd3;
    maintainers = with maintainers; [ garbas ];
  };

}
