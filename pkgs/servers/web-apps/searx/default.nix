{ stdenv, pythonPackages, fetchFromGitHub }:

pythonPackages.buildPythonApplication rec {
  name = "searx-${version}";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "searx";
    rev = "v${version}";
    sha256 = "196lk8dpv8fsjgmwlqik6j6rabvfid41fir6lzqy03hv7ydcw1k0";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace 'certifi==2017.1.23' 'certifi' \
      --replace 'lxml==3.7.3' 'lxml' \
      --replace 'pyopenssl==16.2.0' 'pyopenssl' \
      --replace 'pygments==2.1.3' 'pygments>=2.1,<3.0'
  '';

  propagatedBuildInputs = with pythonPackages; [
    pyyaml lxml grequests flaskbabel flask requests
    gevent speaklater Babel pytz dateutil pygments
    pyasn1 pyasn1-modules ndg-httpsclient certifi pysocks
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/asciimoo/searx;
    description = "A privacy-respecting, hackable metasearch engine";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ matejc fpletz profpatsch ];
  };
 }
