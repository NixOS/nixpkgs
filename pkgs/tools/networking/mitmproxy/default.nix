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
    # Bump pyopenssl dependency
    # https://github.com/mitmproxy/mitmproxy/pull/2252
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/mitmproxy/mitmproxy/pull/2252.patch";
      sha256 = "1smld21df79249qbh412w8gi2agcf4zjhxnlawy19yjl1fk2h67c";
    })
  ];

  propagatedBuildInputs = with python3Packages; [
    blinker click certifi construct cryptography
    cssutils editorconfig h2 html2text hyperframe
    jsbeautifier kaitaistruct passlib pyasn1 pyopenssl
    pyparsing pyperclip requests ruamel_yaml tornado
    urwid watchdog brotlipy sortedcontainers
  ];

  # Tests fail due to an error with a decorator
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Man-in-the-middle proxy";
    homepage = http://mitmproxy.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
  };
}
