{
  stdenv, python2, openssl,

  # Many Salt modules require various Python modules to be installed,
  # passing them in this array enables Salt to find them.
  extraInputs ? []
}:

let

  py = python2.override {
    packageOverrides = self: super: {
      pyyaml = super.pyyaml.overridePythonAttrs (
        oldAttrs: rec {
          version = "3.13";
          src = oldAttrs.src.override {
            inherit version;
            sha256 = "1gx603g484z46cb74j9rzr6sjlh2vndxayicvlyhxdz98lhhkwry";
          };
          postPatch = "rm ext/_yaml.c";
          doCheck = false;
        }
      );
    };
  };

in
py.pkgs.buildPythonApplication rec {
  pname = "salt";
  version = "2019.2.7";

  src = py.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0wxqw6rca78bn2afrszbfb62bz2323n7vmnznl9jwgvcgzxvqj6n";
  };

  propagatedBuildInputs = with py.pkgs; [
    jinja2
    markupsafe
    msgpack
    pycrypto
    pyyaml
    pyzmq
    requests
    tornado_4
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
