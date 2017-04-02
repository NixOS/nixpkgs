{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  baseName = "mitmproxy";
  name = "${baseName}-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = baseName;
    repo = baseName;
    rev = "v${version}";
    sha256 = "17gvr642skz4a23966lckdbrkh6mx31shi8hmakkvi91sa869i30";
  };

  propagatedBuildInputs = with python3Packages; [
    blinker click certifi construct cryptography
    cssutils editorconfig h2 html2text hyperframe
    jsbeautifier kaitaistruct passlib pyasn1 pyopenssl
    pyparsing pyperclip requests2 ruamel_yaml tornado
    urwid watchdog brotlipy sortedcontainers
  ];

  # Tests fail due to an error with a decorator
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Man-in-the-middle proxy";
    homepage = "http://mitmproxy.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
  };
}
