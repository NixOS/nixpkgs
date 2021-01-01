{ stdenv, fetchFromGitHub, python3Packages, glibcLocales, fetchpatch }:

with python3Packages;

buildPythonPackage rec {
  pname = "mitmproxy";
  version = "5.3.0";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-Wfan1sx0o6cDIihUo05MQ1d7M6fcHfpPJEFnrXt3xxM=";
  };

  postPatch = ''
    # remove dependency constraints
    sed 's/>=\([0-9]\.\?\)\+\( \?, \?<\([0-9]\.\?\)\+\)\?\( \?, \?!=\([0-9]\.\?\)\+\)\?//' -i setup.py
  '';

  doCheck = (!stdenv.isDarwin);

  checkPhase = ''
    export HOME=$(mktemp -d)
    pytest -k 'not test_get_version' # expects a Git repository
  '';

  propagatedBuildInputs = [
    blinker brotli certifi cffi
    click cryptography flask h11
    h2 hpack hyperframe itsdangerous
    jinja2 kaitaistruct ldap3 markupsafe
    passlib protobuf publicsuffix2 pyasn1
    pycparser pyopenssl pyparsing pyperclip
    ruamel_yaml setuptools six sortedcontainers
    tornado urwid werkzeug wsproto zstandard asgiref
    msgpack
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
