{
  stdenv, python2Packages, openssl,

  # Many Salt modules require various Python modules to be installed,
  # passing them in this array enables Salt to find them.
  extraInputs ? []
}:

python2Packages.buildPythonApplication rec {
  pname = "salt";
  version = "2017.7.4";

  src = python2Packages.fetchPypi {
    inherit pname version;
    sha256 = "15xfvclk3ns8vk17j7bfy4alq7ab5x3y3jnpqzp5583bfyak0mqx";
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
