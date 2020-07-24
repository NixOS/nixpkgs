{ stdenv, fetchFromGitHub, python3Packages, glibcLocales, fetchpatch }:

with python3Packages;

buildPythonPackage rec {
  pname = "mitmproxy";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1lirlckpvd3c6s6q3p32w4k4yfna5mlgr1x9g39lhzzq0sdiz3lk";
  };

  postPatch = ''
    # remove dependency constraints
    sed 's/>=\([0-9]\.\?\)\+\( \?, \?<\([0-9]\.\?\)\+\)\?//' -i setup.py
  '';

  doCheck = (!stdenv.isDarwin);

  # examples.complex.xss_scanner doesn't import correctly with pytest5
  checkPhase = ''
    export HOME=$(mktemp -d)
    export LC_CTYPE=en_US.UTF-8
    pytest --ignore test/examples \
      -k 'not test_find_unclaimed_URLs and not test_tcp'
  '';

  propagatedBuildInputs = [
    blinker brotli certifi cffi
    click cryptography flask h11
    h2 hpack hyperframe itsdangerous
    jinja2 kaitaistruct ldap3 markupsafe
    passlib protobuf publicsuffix2 pyasn1
    pycparser pyopenssl pyparsing pyperclip
    ruamel_yaml setuptools six sortedcontainers
    tornado urwid werkzeug wsproto zstandard
  ];

  checkInputs = [
    beautifulsoup4 flask pytest
    requests glibcLocales
    asynctest parver pytest-asyncio
    hypothesis
  ];

  meta = with stdenv.lib; {
    description = "Man-in-the-middle proxy";
    homepage    = "https://mitmproxy.org/";
    license     = licenses.mit;
    maintainers = with maintainers; [ fpletz kamilchm ];
  };
}
