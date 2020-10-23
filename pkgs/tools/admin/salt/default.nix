{ lib
, python3
, openssl
  # Many Salt modules require various Python modules to be installed,
  # passing them in this array enables Salt to find them.
, extraInputs ? []
}:
python3.pkgs.buildPythonApplication rec {
  pname = "salt";
  version = "3001.1";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1g2sdcibir0zhldmngv1iyzlhh2adq9dqjc73grap3df5zcv9sz9";
  };

  propagatedBuildInputs = with python3.pkgs; [
    distro
    jinja2
    markupsafe
    msgpack
    pycryptodomex
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

  meta = with lib; {
    homepage = "https://saltstack.com/";
    description = "Portable, distributed, remote execution and configuration management system";
    maintainers = with maintainers; [ Flakebi ];
    license = licenses.asl20;
  };
}
