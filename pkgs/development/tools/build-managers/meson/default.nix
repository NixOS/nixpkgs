{ lib
, python3Packages
, stdenv
, writeTextDir
, substituteAll
, pkgsHostHost
}:

python3Packages.buildPythonApplication rec {
  pname = "meson";
  version = "0.54.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "L3b7RXJ2K+E+5HkpJhAJG0UJr1eIvM6zkf4iK80Cltw=";
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

    # Meson is currently inspecting fewer variables than autoconf does, which
    # makes it harder for us to use setup hooks, etc.  Taken from
    # https://github.com/mesonbuild/meson/pull/6827
    ./more-env-vars.patch

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

  # Ensure there will always be a native C compiler when meson is used, as a
  # workaround until https://github.com/mesonbuild/meson/pull/6512 lands.
  depsHostHostPropagated = [ pkgsHostHost.stdenv.cc ];

  # 0.45 update enabled tests but they are failing
  doCheck = false;
  # checkInputs = [ ninja pkgconfig ];
  # checkPhase = "python ./run_project_tests.py";

  meta = with lib; {
    homepage = "https://mesonbuild.com";
    description = "SCons-like build system that use python as a front-end language and Ninja as a building backend";
    license = licenses.asl20;
    maintainers = with maintainers; [ jtojnar mbe ];
    platforms = platforms.all;
  };
}
