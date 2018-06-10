{
  stdenv, python2Packages, openssl,

  # Many Salt modules require various Python modules to be installed,
  # passing them in this array enables Salt to find them.
  extraInputs ? []
}:

let
  # Use tornado-4.x until https://github.com/saltstack/salt/issues/45790 is resolved
  tornado = python2Packages.tornado.overridePythonAttrs (oldAttrs: rec {
    version = "4.5.3";
    name = "${oldAttrs.pname}-${version}";
    src = oldAttrs.src.override {
      inherit version;
      sha256 = "02jzd23l4r6fswmwxaica9ldlyc2p6q8dk6dyff7j58fmdzf853d";
    };
  });
in
python2Packages.buildPythonApplication rec {
  pname = "salt";
  version = "2018.3.0";

  src = python2Packages.fetchPypi {
    inherit pname version;
    sha256 = "0cbbnmaynnpfknmppzlz04mqw4d3d2ay1dqrli11b5pnzli5v950";
  };

  propagatedBuildInputs = with python2Packages; [
    futures
    jinja2
    markupsafe
    msgpack-python
    pycrypto
    pyyaml
    pyzmq
    requests
    tornado
  ] ++ extraInputs;

  patches = [ ./fix-libcrypto-loading.patch ];

  postPatch = ''
    substituteInPlace "salt/utils/rsax931.py" \
      --subst-var-by "libcrypto" "${openssl.out}/lib/libcrypto.so"
  '';

  # The tests fail due to socket path length limits at the very least;
  # possibly there are more issues but I didn't leave the test suite running
  # as is it rather long.
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://saltstack.com/;
    description = "Portable, distributed, remote execution and configuration management system";
    maintainers = with maintainers; [ aneeshusa ];
    license = licenses.asl20;
  };
}
