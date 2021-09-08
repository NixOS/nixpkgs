{ lib, stdenv, python3, openssl
, enableSystemd ? stdenv.isLinux, nixosTests
, enableRedis ? false
, callPackage
}:

let
  py = python3.override {
    packageOverrides = self: super:  {
      twisted = super.twisted.overridePythonAttrs (oldAttrs: rec {
        version = "21.7.0";
        src = oldAttrs.src.override {
          inherit version;
          extension = "tar.gz";
          sha256 = "01lh225d7lfnmfx4f4kxwl3963gjc9yg8jfkn1w769v34ia55mic";
        };

        propagatedBuildInputs = with self; oldAttrs.propagatedBuildInputs ++ [ typing-extensions ];
      });
    };
  };
  plugins = py.pkgs.callPackage ./plugins { };
  tools = callPackage ./tools { };
in
with py.pkgs; buildPythonApplication rec {
  pname = "matrix-synapse";
  version = "1.42.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wJFjjm9apRqjk5eN/kIEgecHgm/XLbtwXHEpM2pmvO8=";
  };

  patches = [
    ./0001-setup-add-homeserver-as-console-script.patch
  ];

  buildInputs = [ openssl ];

  propagatedBuildInputs = [
    authlib
    bcrypt
    bleach
    canonicaljson
    daemonize
    frozendict
    ijson
    jinja2
    jsonschema
    lxml
    msgpack
    netaddr
    phonenumbers
    pillow
    prometheus_client
    psutil
    psycopg2
    pyasn1
    pyjwt
    pymacaroons
    pynacl
    pyopenssl
    pysaml2
    pyyaml
    requests
    setuptools
    signedjson
    sortedcontainers
    treq
    twisted
    typing-extensions
    unpaddedbase64
  ] ++ lib.optional enableSystemd systemd
    ++ lib.optional enableRedis hiredis;

  checkInputs = [ mock parameterized openssl ];

  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    PYTHONPATH=".:$PYTHONPATH" ${python3.interpreter} -m twisted.trial tests
  '';

  passthru.tests = { inherit (nixosTests) matrix-synapse; };
  passthru.plugins = plugins;
  passthru.tools = tools;
  passthru.python = python3;

  meta = with lib; {
    homepage = "https://matrix.org";
    description = "Matrix reference homeserver";
    license = licenses.asl20;
    maintainers = teams.matrix.members;
  };
}
