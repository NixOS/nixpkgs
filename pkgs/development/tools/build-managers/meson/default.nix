{ lib, python3Packages, stdenv, writeTextDir, substituteAll, targetPackages, fetchpatch }:

python3Packages.buildPythonApplication rec {
  version = "0.48.2";
  pname = "meson";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1shfbr0mf8gmwpw5ivrmwp8282qw9mfhxmccd7fsgidp4x3nslby";
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

    # Unlike libtool, vanilla Meson does not pass any information
    # about the path library will be installed to to g-ir-scanner,
    # breaking the GIR when path other than ${!outputLib}/lib is used.
    # We patch Meson to add a --fallback-library-path argument with
    # library install_dir to g-ir-scanner.
    ./gir-fallback-path.patch

    # In common distributions, RPATH is only needed for internal libraries so
    # meson removes everything else. With Nix, the locations of libraries
    # are not as predictable, therefore we need to keep them in the RPATH.
    # At the moment we are keeping the paths starting with /nix/store.
    # https://github.com/NixOS/nixpkgs/issues/31222#issuecomment-365811634
    (substituteAll {
      src = ./fix-rpath.patch;
      inherit (builtins) storeDir;
    })

    # Support Python 3.7. This is part of 0.47 and 0.48.1.
    (fetchpatch {
      url = https://github.com/mesonbuild/meson/commit/a87496addd9160300837aa50193f4798c6f1d251.patch;
      sha256 = "1jfn9dgib5bc8frcd65cxn3fzhp19bpbjadxjkqzbjk1v4hdbl88";
    })
  ];

  setupHook = ./setup-hook.sh;

  crossFile = writeTextDir "cross-file.conf" ''
    [binaries]
    c = '${targetPackages.stdenv.cc.targetPrefix}cc'
    cpp = '${targetPackages.stdenv.cc.targetPrefix}c++'
    ar = '${targetPackages.stdenv.cc.bintools.targetPrefix}ar'
    strip = '${targetPackages.stdenv.cc.bintools.targetPrefix}strip'
    pkgconfig = 'pkg-config'

    [properties]
    needs_exe_wrapper = true

    [host_machine]
    system = '${targetPackages.stdenv.targetPlatform.parsed.kernel.name}'
    cpu_family = '${targetPackages.stdenv.targetPlatform.parsed.cpu.family}'
    cpu = '${targetPackages.stdenv.targetPlatform.parsed.cpu.name}'
    endian = ${if targetPackages.stdenv.targetPlatform.isLittleEndian then "'little'" else "'big'"}
  '';

  # 0.45 update enabled tests but they are failing
  doCheck = false;
  # checkInputs = [ ninja pkgconfig ];
  # checkPhase = "python ./run_project_tests.py";

  inherit (stdenv) cc;

  isCross = stdenv.targetPlatform != stdenv.hostPlatform;

  meta = with lib; {
    homepage = http://mesonbuild.com;
    description = "SCons-like build system that use python as a front-end language and Ninja as a building backend";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbe rasendubi ];
    platforms = platforms.all;
  };
}
