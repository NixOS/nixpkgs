{ stdenv, fetchpatch, fetchFromGitHub, python3 }:

let
  # mitmproxy needs an older tornado version
  python = python3.override {
    packageOverrides = self: super: {
      tornado = super.tornado.overridePythonAttrs (oldAttrs: rec {
        version = "4.4.3";
        name = "${oldAttrs.pname}-${version}";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "f267acc96d5cf3df0fd8a7bfb5a91c2eb4ec81d5962d1a7386ceb34c655634a8";
        };
      });
    };
  };
in python.pkgs.buildPythonPackage rec {
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

  propagatedBuildInputs = with python.pkgs; [
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
