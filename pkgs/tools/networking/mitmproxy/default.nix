{ stdenv, fetchFromGitHub, python3Packages, glibcLocales }:

with python3Packages;

let publicsuffix2 = python3Packages.callPackage ./publicsuffix2.nix {};
    zstandard = python3Packages.callPackage ./zstandard.nix {};
in
buildPythonPackage rec {
  pname = "mitmproxy";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1ywmp1pjh5acwfiqqh4zxgdnhv2a6ca008m0p31vw8czylj5slim";
  };

  postPatch = ''
    # remove dependency constraints
    sed 's/>=\([0-9]\.\?\)\+\( \?, \?<\([0-9]\.\?\)\+\)\?//' -i setup.py
    sed 's/==\([0-9]\.\?\)\+\( \?, \?<\([0-9]\.\?\)\+\)\?//' -i setup.py
  '';

  checkPhase = ''
    export HOME=$(mktemp -d)
    export LC_CTYPE=en_US.UTF-8
    pytest -k 'not test_find_unclaimed_URLs and not test_tcp'
  '';

  propagatedBuildInputs = [
    blinker click certifi cryptography
    h2 hyperframe kaitaistruct passlib
    pyasn1 pyopenssl pyparsing pyperclip
    ruamel_yaml tornado urwid brotli
    sortedcontainers ldap3 wsproto setuptools
    publicsuffix2 zstandard flask protobuf
  ];

  checkInputs = [
    beautifulsoup4 flask pytest
    requests glibcLocales
    asynctest parver pytest-asyncio
  ];

  meta = with stdenv.lib; {
    description = "Man-in-the-middle proxy";
    homepage    = "https://mitmproxy.org/";
    license     = licenses.mit;
    maintainers = with maintainers; [ fpletz kamilchm ];
  };
}
