{ stdenv, fetchpatch, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  baseName = "mitmproxy";
  name = "${baseName}-${version}";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = baseName;
    repo = baseName;
    rev = "v${version}";
    sha256 = "1x1a28al5clpfd69rjcpw26gjjnpsm1vfl4scrwpdd1jhkw044h9";
  };

  patches = [
    # fix tests
    (fetchpatch {
      url = "https://github.com/mitmproxy/mitmproxy/commit/b3525570929ba47c10d9d08696876c39487f7000.patch";
      sha256 = "111fld5gqdii7rs1jhqaqrxgbyhfn6qd0y7l15k4npamsnvdnv20";
    })
    # bump pyOpenSSL
    (fetchpatch {
      url = https://github.com/mitmproxy/mitmproxy/commit/6af72160bf98b58682b8f9fc5aabf51928d2b1d3.patch;
      sha256 = "1q4ml81pq9c8j9iscq8janbxf4s37w3bqskbs6r30yqzy63v54f2";
    })
    # https://github.com/mitmproxy/mitmproxy/commit/3d7cde058b7e6242d93b9bc9d3e17520ffb578a5
    ./tornado-4.6.patch
  ];

  checkPhase = ''
    export HOME=$(mktemp -d)
    LC_CTYPE=en_US.UTF-8 python setup.py pytest
  '';

  propagatedBuildInputs = with python3Packages; [
    blinker click certifi construct cryptography
    cssutils editorconfig h2 html2text hyperframe
    jsbeautifier kaitaistruct passlib pyasn1 pyopenssl
    pyparsing pyperclip requests ruamel_yaml tornado
    urwid watchdog brotlipy sortedcontainers
  ];

  buildInputs = with python3Packages; [
    beautifulsoup4 flask pytz pytest pytestrunner protobuf3_2
  ];

  meta = with stdenv.lib; {
    description = "Man-in-the-middle proxy";
    homepage = http://mitmproxy.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
  };
}
