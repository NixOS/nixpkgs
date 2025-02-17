{
  lib,
  stdenv,
  udev,
  openssl,
  boost,
  cmake,
  git,
  ...
}:

let
  version = "1.13.0";
  baseDrv = {
    src = builtins.fetchGit {
      url = "https://github.com/intel/linux-npu-driver.git";
      ref = version;
      submodules = true;
    };

    buildInputs = [
      udev
      openssl
      boost
    ];

    nativeBuildInputs = [
      cmake
      git
    ];
  };
  mkInstallPhase = lib.concatMapStringsSep "\n" (
    component: "cmake --install build --component ${component} --prefix $out"
  );
in
stdenv.mkDerivation {
  inherit version;
  inherit (baseDrv) src buildInputs nativeBuildInputs;
  pname = "intel-npu-driver-standalone";

  installPhase = mkInstallPhase [
    "level-zero-npu"
    "validation-npu"
  ];

  meta = {
    homepage = "https://github.com/intel/linux-npu-driver";
    description = "Intel NPU (Neural Processing Unit) Standalone Driver";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
    mainProgram = "npu-umd-test";
    maintainers = with lib.maintainers; [ pseudocc ];
  };

  passthru.level-zero = stdenv.mkDerivation {
    inherit (baseDrv) src buildInputs nativeBuildInputs;
    pname = "intel-npu-level-zero";
    version = "${version}-1.18.5";

    installPhase = mkInstallPhase [ "level-zero" ];

    meta = {
      homepage = "https://github.com/oneapi-src/level-zero";
      description = "oneAPI Level Zero Specification Headers and Loader";
      platforms = [ "x86_64-linux" ];
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ pseudocc ];
    };
  };
}
