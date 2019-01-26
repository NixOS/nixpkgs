{ stdenv, fetchFromGitHub, python3Packages, glibcLocales, fetchpatch }:

with python3Packages;

buildPythonPackage rec {
  pname = "mitmproxy";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "v${version}";
    sha256 = "14i9dkafvyl15rq2qa8xldscn5lmkk2g52kbi2hl63nzx9yibx6r";
  };

  patches = [
    (fetchpatch {
      # Tests failed due to expired test certificates,
      # https://github.com/mitmproxy/mitmproxy/issues/3316
      # TODO: remove on next update
      name = "test-certificates.patch";
      url = "https://github.com/mitmproxy/mitmproxy/commit/1b6a8d6acd3d70f9b9627ad4ae9def08103f8250.patch";
      sha256 = "03y79c25yir7d8xj79czdc81y3irqq1i3ks9ca0mv1az8b7xsvfv";
    })
  ];

  postPatch = ''
    # remove dependency constraints
    sed 's/>=\([0-9]\.\?\)\+\( \?, \?<\([0-9]\.\?\)\+\)\?//' -i setup.py
  '';

  doCheck = (!stdenv.isDarwin);

  checkPhase = ''
    export HOME=$(mktemp -d)
    export LC_CTYPE=en_US.UTF-8
    pytest -k 'not test_find_unclaimed_URLs'
  '';

  propagatedBuildInputs = [
    blinker click certifi cryptography
    h2 hyperframe kaitaistruct passlib
    pyasn1 pyopenssl pyparsing pyperclip
    ruamel_yaml tornado urwid brotlipy
    sortedcontainers ldap3 wsproto
  ];

  checkInputs = [
    beautifulsoup4 flask pytest
    requests glibcLocales
    asynctest parver pytest-asyncio
  ];

  meta = with stdenv.lib; {
    description = "Man-in-the-middle proxy";
    homepage    = https://mitmproxy.org/;
    license     = licenses.mit;
    maintainers = with maintainers; [ fpletz kamilchm ];
  };
}
