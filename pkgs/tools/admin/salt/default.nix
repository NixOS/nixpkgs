{
  stdenv, fetchurl, python2Packages, openssl,

  # Many Salt modules require various Python modules to be installed,
  # passing them in this array enables Salt to find them.
  extraInputs ? []
}:

python2Packages.buildPythonApplication rec {
  name = "salt-${version}";
  version = "2016.11.2";

  src = fetchurl {
    url = "mirror://pypi/s/salt/${name}.tar.gz";
    sha256 = "0hrss5x47cr7ffyjl8jlkhf9j88lqvg7c33rjc5bimck8b7x7hzm";
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
