{ lib
, stdenv
, python3
, fetchpatch
, fetchPypi
, openssl
  # Many Salt modules require various Python modules to be installed,
  # passing them in this array enables Salt to find them.
, extraInputs ? []
}:

python3.pkgs.buildPythonApplication rec {
  pname = "salt";
  version = "3006.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-flP7zETEn41uZ8sZytoGOADKKe1/Fa+XJSdTGqhW5Cs=";
  };

  patches = [
    # https://github.com/saltstack/salt/pull/63795
    (fetchpatch {
      name = "remove-duplicate-scripts.patch";
      url = "https://github.com/saltstack/salt/commit/6b9463836e70e40409dbf653f01aa94ef869dfe7.patch";
      hash = "sha256-VcVdKC8EH4qoWHtq6eEPl8OviR4eA2k/S2lWNQbubJw=";
    })
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
