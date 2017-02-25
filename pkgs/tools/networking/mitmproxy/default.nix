{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  baseName = "mitmproxy";
  name = "${baseName}-${version}";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = baseName;
    repo = baseName;
    rev = "v${version}";
    sha256 = "19nqg7s1034fal8sb2rjssgcpvxh50yidyjhnbfmmi8v3fbvpbwl";
  };

  propagatedBuildInputs = with python3Packages; [
    pyopenssl pyasn1 urwid pillow flask click pyperclip blinker
    construct pyparsing html2text tornado brotlipy requests2
    sortedcontainers passlib cssutils h2 ruamel_yaml jsbeautifier
    watchdog editorconfig
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
