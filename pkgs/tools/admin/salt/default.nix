{ lib
, fetchFromGitHub
, python3
, openssl
  # Many Salt modules require various Python modules to be installed,
  # passing them in this array enables Salt to find them.
, extraInputs ? []
}:

let
  py = python3.override {
    packageOverrides = self: super: {
      # Incompatible with pyzmq 22
      pyzmq = super.pyzmq.overridePythonAttrs (oldAttrs: rec {
        version = "21.0.2";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "CYwTxhmJE8KgaQI1+nTS5JFhdV9mtmO+rsiWUVVMx5w=";
        };
      });
   };
  };
in
py.pkgs.buildPythonApplication rec {
  pname = "salt";
  # Unstable because 3004.1 is not compatible with jinja2 3.1
  version = "unstable-2022-05-03";

  src = fetchFromGitHub {
    owner = "saltstack";
    repo = pname;
    rev = "72a673ba2c24651dcd88c825f0a60f081b4ae665";
    hash = "sha256-dqYbU1pu/K+yQZX7AlS7N5dz/Dm22GTTD5Tzs4k7TPI=";
  };

  propagatedBuildInputs = with py.pkgs; [
    distro
    jinja2
    markupsafe
    msgpack
    psutil
    pycryptodomex
    pyyaml
    pyzmq
    requests
    tornado
  ] ++ extraInputs;

  patches = [ ./fix-libcrypto-loading.patch ];

  postPatch = ''
    substituteInPlace "salt/utils/rsax931.py" \
      --subst-var-by "libcrypto" "${lib.getLib openssl}/lib/libcrypto.so"
    substituteInPlace requirements/base.txt \
      --replace contextvars ""
  '';

  # The tests fail due to socket path length limits at the very least;
  # possibly there are more issues but I didn't leave the test suite running
  # as is it rather long.
  doCheck = false;

  meta = with lib; {
    homepage = "https://saltproject.io/";
    changelog = "https://docs.saltproject.io/en/latest/topics/releases/${version}.html";
    description = "Portable, distributed, remote execution and configuration management system";
    maintainers = with maintainers; [ Flakebi ];
    license = licenses.asl20;
  };
}
