{ lib, fetchpatch, python3Packages, stdenv, writeTextDir, substituteAll }:

python3Packages.buildPythonApplication rec {
  version = "0.48.0";
  pname = "meson";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0qawsm6px1vca3babnqwn0hmkzsxy4w0gi345apd2qk3v0cv7ipc";
  };

  postFixup = ''
    pushd $out/bin
    # undo shell wrapper as meson tools are called with python
    for i in *; do
      mv ".$i-wrapped" "$i"
    done
    popd

    # Do not propagate Python
    rm $out/nix-support/propagated-build-inputs
  '';

  patches = [
    # Upstream insists on not allowing bindir and other dir options
    # outside of prefix for some reason:
    # https://github.com/mesonbuild/meson/issues/2561
    # We remove the check so multiple outputs can work sanely.
    ./allow-dirs-outside-of-prefix.patch

    # In common distributions, RPATH is only needed for internal libraries so
    # meson removes everything else. With Nix, the locations of libraries
    # are not as predictable, therefore we need to keep them in the RPATH.
    # At the moment we are keeping the paths starting with /nix/store.
    # https://github.com/NixOS/nixpkgs/issues/31222#issuecomment-365811634
    (substituteAll {
      src = ./fix-rpath.patch;
      inherit (builtins) storeDir;
    })

    # Fix building file-roller
    # https://github.com/mesonbuild/meson/issues/4304
    # will be included in 0.48.1
    (fetchpatch {
      url = https://github.com/mesonbuild/meson/commit/238710cfab18da9d7c4091133b57e0bf638a6020.patch;
      sha256 = "012457l2hz5xr2ach07ixjqy2b6ccmplqv1xgnic605c4jagbv9s";
    })
  ];

  setupHook = ./setup-hook.sh;

  crossFile = writeTextDir "cross-file.conf" ''
    [binaries]
    c = '${stdenv.cc.targetPrefix}cc'
    cpp = '${stdenv.cc.targetPrefix}c++'
    ar = '${stdenv.cc.bintools.targetPrefix}ar'
    strip = '${stdenv.cc.bintools.targetPrefix}strip'
    pkgconfig = 'pkg-config'

    [properties]
    needs_exe_wrapper = true

    [host_machine]
    system = '${stdenv.targetPlatform.parsed.kernel.name}'
    cpu_family = '${stdenv.targetPlatform.parsed.cpu.family}'
    cpu = '${stdenv.targetPlatform.parsed.cpu.name}'
    endian = ${if stdenv.targetPlatform.isLittleEndian then "'little'" else "'big'"}
  '';

  # 0.45 update enabled tests but they are failing
  doCheck = false;
  # checkInputs = [ ninja pkgconfig ];
  # checkPhase = "python ./run_project_tests.py";

  inherit (stdenv) cc;

  isCross = stdenv.buildPlatform != stdenv.hostPlatform;

  meta = with lib; {
    homepage = http://mesonbuild.com;
    description = "SCons-like build system that use python as a front-end language and Ninja as a building backend";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbe rasendubi ];
    platforms = platforms.all;
  };
}
