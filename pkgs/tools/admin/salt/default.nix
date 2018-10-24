{
  stdenv, pythonPackages, openssl,

  # Many Salt modules require various Python modules to be installed,
  # passing them in this array enables Salt to find them.
  extraInputs ? []
}:

pythonPackages.buildPythonApplication rec {
  pname = "salt";
  version = "2018.3.2";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "d86eeea2e5387f4a64bbf0a11d103bfc8aac1122e19d39cc0945d33efdc797bd";
  };

  propagatedBuildInputs = with pythonPackages; [
    jinja2
    markupsafe
    msgpack
    pycrypto
    pyyaml
    pyzmq
    requests
    tornado_4
  ] ++ stdenv.lib.optional (!pythonPackages.isPy3k) [
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
