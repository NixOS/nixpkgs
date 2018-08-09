{ lib, python3Packages, stdenv, targetPlatform, writeTextDir, substituteAll }:

python3Packages.buildPythonApplication rec {
  version = "0.46.1";
  pname = "meson";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1jdxs2mkniy1hpdjc4b4jb95axsjp6j5fzphmm6d4gqmqyykjvqc";
  };

  postFixup = ''
    pushd $out/bin
    # undo shell wrapper as meson tools are called with python
    for i in *; do
      mv ".$i-wrapped" "$i"
    done
    popd
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
    system = '${targetPlatform.parsed.kernel.name}'
    cpu_family = '${targetPlatform.parsed.cpu.family}'
    cpu = '${targetPlatform.parsed.cpu.name}'
    endian = ${if targetPlatform.isLittleEndian then "'little'" else "'big'"}
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
