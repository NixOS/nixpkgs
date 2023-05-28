{ lib
, stdenv
, python3
, fetchPypi
, openssl
  # Many Salt modules require various Python modules to be installed,
  # passing them in this array enables Salt to find them.
, extraInputs ? []
}:

python3.pkgs.buildPythonApplication rec {
  pname = "salt";
  version = "3006.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lVh71hHepq/7aQjQ7CaGy37bhMFBRLSFF3bxJ6YOxbk=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    distro
    jinja2
    jmespath
    looseversion
    markupsafe
    msgpack
    packaging
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
      --subst-var-by "libcrypto" "${lib.getLib openssl}/lib/libcrypto${stdenv.hostPlatform.extensions.sharedLibrary}"
    substituteInPlace requirements/base.txt \
      --replace contextvars ""

    # Don't require optional dependencies on Darwin, let's use
    # `extraInputs` like on any other platform
    echo -n > "requirements/darwin.txt"

    # Remove windows-only requirement
    substituteInPlace "requirements/zeromq.txt" \
      --replace 'pyzmq==25.0.2 ; sys_platform == "win32"' ""
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
