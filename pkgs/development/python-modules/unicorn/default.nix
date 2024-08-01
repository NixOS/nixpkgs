{
  lib,
  stdenv,
  buildPythonPackage,
  setuptools,
  unicorn-emu,
}:

buildPythonPackage rec {
  pname = "unicorn";
  version = lib.getVersion unicorn-emu;
  format = "setuptools";

  src = unicorn-emu.src;

  sourceRoot = "${src.name}/bindings/python";

  patches = [
    # Python 3.12 compatibility: Drop removed `distutils` import in favor of `sysconfig`
    ./avoid-distutils-python312.patch
  ];

  prePatch = ''
    ln -s ${unicorn-emu}/lib/libunicorn.* prebuilt/
  '';

  # needed on non-x86 linux
  setupPyBuildFlags =
    lib.optionals stdenv.isLinux [
      "--plat-name"
      "linux"
    ]
    # aarch64 only available from MacOS SDK 11 onwards, so fix the version tag.
    # otherwise, bdist_wheel may detect "macosx_10_6_arm64" which doesn't make sense.
    ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
      "--plat-name"
      "macosx_11_0"
    ];

  propagatedBuildInputs = [ setuptools ];

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
    maintainers = with maintainers; [
      bennofs
      ris
    ];
  };
}
