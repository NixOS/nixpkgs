{ lib
, python3
, openssl
  # Many Salt modules require various Python modules to be installed,
  # passing them in this array enables Salt to find them.
, extraInputs ? []
}:
let

  py = python3.override {
    packageOverrides = self: super: {
      # Can be unpinned once https://github.com/saltstack/salt/issues/56007 is resolved
      msgpack = super.msgpack.overridePythonAttrs (
        oldAttrs: rec {
          version = "0.6.2";
          src = oldAttrs.src.override {
            inherit version;
            sha256 = "0c0q3vx0x137567msgs5dnizghnr059qi5kfqigxbz26jf2jyg7a";
          };
        }
      );
    };
  };

in
py.pkgs.buildPythonApplication rec {
  pname = "salt";
  version = "3000.3";

  src = py.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "19yfjhidx93rl9s03lvrfz7kp0xxigyv4d3zb9792zb9bsc4kjpw";
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

  meta = with lib; {
    homepage = "https://saltstack.com/";
    description = "Portable, distributed, remote execution and configuration management system";
    maintainers = with maintainers; [ aneeshusa ];
    license = licenses.asl20;
  };
}
