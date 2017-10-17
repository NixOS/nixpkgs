{ stdenv, fetchpatch, fetchFromGitHub, fetchurl, python3, glibcLocales }:

let
  p = python3.override {
    packageOverrides = self: super: {
      cryptography = super.cryptography.overridePythonAttrs (oldAttrs: rec {
        version = "1.8.2";
        name = "${oldAttrs.pname}-${version}";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "8e88ebac371a388024dab3ccf393bf3c1790d21bc3c299d5a6f9f83fb823beda";
        };
      });
      cryptography_vectors = super.cryptography_vectors.overridePythonAttrs (oldAttrs: rec {
        version = self.cryptography.version;
        name = "${oldAttrs.pname}-${version}";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "00daa04c9870345f56605d91d7d4897bc1b16f6fff7c74cb602b08ef16c0fb43";
        };
      });
      pyopenssl = super.pyopenssl.overridePythonAttrs (oldAttrs: rec {
        version = "17.0.0";
        name = "${oldAttrs.pname}-${version}";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1pdg1gpmkzj8yasg6cmkhcivxcdp4c12nif88y4qvsxq5ffzxas8";
        };
        patches = fetchpatch {
          url = "https://github.com/pyca/pyopenssl/commit/"
              + "a40898b5f1d472f9449a344f703fa7f90cddc21d.patch";
          sha256 = "0bdfrhfvdfxhfknn46s4db23i3hww6ami2r1l5rfrri0pn8b8mh7";
        };
      });
    };
  };
in p.pkgs.buildPythonPackage rec {
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
    # test_echo resolves hostnames
    LC_CTYPE=en_US.UTF-8 pytest -k 'not test_echo'
  '';

  propagatedBuildInputs = with p.pkgs; [
    blinker click certifi construct cryptography
    cssutils editorconfig h2 html2text hyperframe
    jsbeautifier kaitaistruct passlib pyasn1 pyopenssl
    pyparsing pyperclip requests ruamel_yaml tornado
    urwid watchdog brotlipy sortedcontainers
  ];

  buildInputs = with p.pkgs; [
    beautifulsoup4 flask pytz pytest pytestrunner protobuf glibcLocales
  ];

  meta = with stdenv.lib; {
    description = "Man-in-the-middle proxy";
    homepage = http://mitmproxy.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz kamilchm ];
  };
}
