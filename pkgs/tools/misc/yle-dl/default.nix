{ stdenv, fetchFromGitHub, rtmpdump, php, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "yle-dl-${version}";
  version = "2.28";

  src = fetchFromGitHub {
    owner = "aajanki";
    repo = "yle-dl";
    rev = version;
    sha256 = "1nb3gmkizgkd09slihc2iaf3rh1s7bdhy9zydkfghmqi7nv4mmq0";
  };

  propagatedBuildInputs = with pythonPackages; [ lxml pyamf pycrypto requests ];
  pythonPath = [ rtmpdump php ];

  doCheck = false; # tests require network access
  checkInputs = with pythonPackages; [ pytest pytestrunner ];

  meta = with stdenv.lib; {
    description = "Downloads videos from Yle (Finnish Broadcasting Company) servers";
    homepage = https://aajanki.github.io/yle-dl/;
    license = licenses.gpl3;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
