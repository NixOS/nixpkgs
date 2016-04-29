{
  stdenv, fetchurl, pythonPackages, openssl,

  # Many Salt modules require various Python modules to be installed,
  # passing them in this array enables Salt to find them.
  extraInputs ? []
}:

pythonPackages.buildPythonApplication rec {
  name = "salt-${version}";
  version = "2015.8.8";

  disabled = pythonPackages.isPy3k;

  src = fetchurl {
    url = "mirror://pypi/s/salt/${name}.tar.gz";
    sha256 = "1xcfcs50pyammb60myph4f8bi2r6iwkxwsnnhrjwvkv2ymxwxv5j";
  };

  propagatedBuildInputs = with pythonPackages; [
    futures
    jinja2
    markupsafe
    msgpack
    pycrypto
    pyyaml
    pyzmq
    requests
    salttesting
    tornado
  ] ++ extraInputs;

  patches = [ ./fix-libcrypto-loading.patch ];

  postPatch = ''
    substituteInPlace "salt/utils/rsax931.py" \
      --subst-var-by "libcrypto" "${openssl}/lib/libcrypto.so"
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
