{
  lib,
  stdenv,
  buildPythonPackage,
  distutils,
  setuptools,
  unicorn-angr,
}:

buildPythonPackage rec {
  pname = "unicorn-angr";
  version = lib.getVersion unicorn-angr;
  pyproject = true;

  src = unicorn-angr.src;

  sourceRoot = "${src.name}/bindings/python";

  prePatch = ''
    ln -s ${unicorn-angr}/lib/libunicorn.* prebuilt/
  '';

  # Needed on non-x86 linux
  setupPyBuildFlags =
    lib.optionals stdenv.hostPlatform.isLinux [
      "--plat-name"
      "linux"
    ]
    # aarch64 only available from MacOS SDK 11 onwards, so fix the version tag.
    # otherwise, bdist_wheel may detect "macosx_10_6_arm64" which doesn't make sense.
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      "--plat-name"
      "macosx_11_0"
    ];

  build-system = [
    distutils
    setuptools
  ];

  checkPhase = ''
    runHook preCheck

    mv unicorn unicorn.hidden
    patchShebangs sample_*.py shellcode.py
    sh -e sample_all.sh

    runHook postCheck
  '';

  pythonImportsCheck = [ "unicorn" ];

  meta = with lib; {
    description = "Python bindings for Unicorn CPU emulator engine";
    homepage = "https://www.unicorn-engine.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fab ];
  };
}
