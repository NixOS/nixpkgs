{
  stdenv, python2Packages, openssl,

  # Many Salt modules require various Python modules to be installed,
  # passing them in this array enables Salt to find them.
  extraInputs ? []
}:

python2Packages.buildPythonApplication rec {
  pname = "salt";
  version = "2019.2.0";

  src = python2Packages.fetchPypi {
    inherit pname version;
    sha256 = "1kgn3lway0zwwysyzpphv05j4xgxk92dk4rv1vybr2527wmvp5an";
  };

  propagatedBuildInputs = with python2Packages; [
    jinja2
    markupsafe
    msgpack
    pycrypto
    pyyaml
    pyzmq
    requests
    tornado_4
  ] ++ stdenv.lib.optional (!python2Packages.isPy3k) [
    futures
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
