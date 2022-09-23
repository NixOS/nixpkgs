{ lib
, python3
, openssl
, fetchpatch
  # Many Salt modules require various Python modules to be installed,
  # passing them in this array enables Salt to find them.
, extraInputs ? []
}:

python3.pkgs.buildPythonApplication rec {
  pname = "salt";
  version = "3005";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-HSAMRbiARheOpW+1p1cm3GIMxeUUEQdqBN+A/1L3nNQ=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    distro
    jinja2
    markupsafe
    msgpack
    psutil
    pycryptodomex
    pyyaml
    pyzmq
    requests
  ] ++ extraInputs;

  patches = [
    ./fix-libcrypto-loading.patch
  ];

  postPatch = ''
    substituteInPlace "salt/utils/rsax931.py" \
      --subst-var-by "libcrypto" "${lib.getLib openssl}/lib/libcrypto.so"
    substituteInPlace requirements/base.txt \
      --replace contextvars ""

    # Don't require optional dependencies on Darwin, let's use
    # `extraInputs` like on any other platform
    echo -n > "requirements/darwin.txt"

    # 3004.1: requirement of pyzmq was restricted to <22.0.0; looks like that req was incorrect
    # https://github.com/saltstack/salt/commit/070597e525bb7d56ffadede1aede325dfb1b73a4
    # https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=259279
    # https://github.com/saltstack/salt/pull/61163
    substituteInPlace "requirements/zeromq.txt" \
      --replace 'pyzmq<=20.0.0 ; python_version < "3.6"' "" \
      --replace 'pyzmq>=17.0.0,<22.0.0 ; python_version < "3.9"' 'pyzmq>=17.0.0 ; python_version < "3.9"' \
      --replace 'pyzmq>19.0.2,<22.0.0 ; python_version >= "3.9"' 'pyzmq>19.0.2 ; python_version >= "3.9"'
  '';

  # Don't use fixed dependencies on Darwin
  USE_STATIC_REQUIREMENTS = "0";

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
