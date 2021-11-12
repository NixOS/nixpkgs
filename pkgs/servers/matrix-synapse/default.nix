{ lib, stdenv, python3, openssl
, enableSystemd ? stdenv.isLinux, nixosTests
, enableRedis ? true
, callPackage
}:

let
py = python3.override {
  packageOverrides = self: super: {
    frozendict = super.frozendict.overridePythonAttrs (oldAttrs: rec {
      version = "1.2";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "0ibf1wipidz57giy53dh7mh68f2hz38x8f4wdq88mvxj5pr7jhbp";
      };
      doCheck = false;
    });
  };
};
in

with py.pkgs;

let
  plugins = py.pkgs.callPackage ./plugins { };
  tools = callPackage ./tools { };
in
buildPythonApplication rec {
  pname = "matrix-synapse";
  version = "1.46.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RcB+RSb/LZE8Q+UunyrYh28S7c7VsTmqg4mJIDVCX5U=";
  };

  patches = [
    ./0001-setup-add-homeserver-as-console-script.patch
    ./0002-Expose-generic-worker-as-binary-under-NixOS.patch
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
    prometheus-client
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
    ++ lib.optionals enableRedis [ hiredis txredisapi ];

  checkInputs = [ mock parameterized openssl ];

  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    PYTHONPATH=".:$PYTHONPATH" ${py.interpreter} -m twisted.trial -j $NIX_BUILD_CORES tests
  '';

  passthru.tests = { inherit (nixosTests) matrix-synapse; };
  passthru.plugins = plugins;
  passthru.tools = tools;
  passthru.python = py;

  meta = with lib; {
    homepage = "https://matrix.org";
    description = "Matrix reference homeserver";
    license = licenses.asl20;
    maintainers = teams.matrix.members;
  };
}
