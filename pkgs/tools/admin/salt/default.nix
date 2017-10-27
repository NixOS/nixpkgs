{
  stdenv, python2Packages, openssl,

  # Many Salt modules require various Python modules to be installed,
  # passing them in this array enables Salt to find them.
  extraInputs ? []
}:

python2Packages.buildPythonApplication rec {
  pname = "salt";
  version = "2017.7.2";
  name = "${pname}-${version}";

  src = python2Packages.fetchPypi {
    inherit pname version;
    sha256 = "0h18zwp1w90rgxpmqgrmn9wp31h03f0vak8lpnnbh0dzbbgcffzz";
  };

  propagatedBuildInputs = with python2Packages; [
    futures
    jinja2
    markupsafe
    msgpack
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
