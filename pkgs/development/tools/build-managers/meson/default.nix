{ lib
, fetchpatch
, installShellFiles
, ninja
, pkg-config
, python3
, substituteAll
, withDarwinFrameworksGtkDocPatch ? false
}:

python3.pkgs.buildPythonApplication rec {
  pname = "meson";
  version = "0.61.2";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-AjOn+NlZB5MY9gUrCTnCf2il3oa6YB8lye5oaftfWIk=";
  };

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

    # Use more binutils variables, so we don't have to define them in stdenv.
    # pr has been merged
    # https://github.com/mesonbuild/meson/pull/10640
    (fetchpatch {
      url = "https://github.com/mesonbuild/meson/commit/8a8ab9a8e0c2cefb6faa0734e52803c74790576c.patch";
      sha256 = "sha256-BdBf1NB4SZLFyFRDzD0p//XUgUeAHpo6XXUtsHdCgKE=";
    })

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

    # When Meson removes build_rpath from DT_RUNPATH entry, it just writes
    # the shorter NUL-terminated new rpath over the old one to reduce
    # the risk of potentially breaking the ELF files.
    # But this can cause much bigger problem for Nix as it can produce
    # cut-in-half-by-\0 store path references.
    # Let’s just clear the whole rpath and hope for the best.
    ./clear-old-rpath.patch

    # Patch out default boost search paths to avoid impure builds on
    # unsandboxed non-NixOS builds, see:
    # https://github.com/NixOS/nixpkgs/issues/86131#issuecomment-711051774
    ./boost-Do-not-add-system-paths-on-nix.patch

    # https://github.com/mesonbuild/meson/pull/9841
    # cross-compilation fix
    (fetchpatch {
      url = "https://github.com/mesonbuild/meson/commit/266e8acb5807b38a550cb5145cea0e19545a21d7.patch";
      sha256 = "sha256-1GdKsm2xvq2GxTNeTyBH5O73hxboL0YI+w2BCoUeWXM=";
    })
  ] ++ lib.optionals withDarwinFrameworksGtkDocPatch [
    # Fix building gtkdoc for GLib
    # https://github.com/mesonbuild/meson/pull/10186
    ./fix-gtkdoc-when-using-multiple-apple-frameworks.patch
  ];

  setupHook = ./setup-hook.sh;

  # Meson included tests since 0.45, however they fail in Nixpkgs because they
  # require a typical building environment (including C compiler and stuff).
  # Just for the sake of documentation, the next lines are maintained here.
  doCheck = false;
  checkInputs = [ ninja pkg-config ];
  checkPhase = ''
    python ./run_project_tests.py
  '';

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

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --zsh data/shell-completions/zsh/_meson
    installShellCompletion --bash data/shell-completions/bash/meson
  '';

  meta = with lib; {
    homepage = "https://mesonbuild.com";
    description = "An open source, fast and friendly build system made in Python";
    longDescription = ''
      Meson is an open source build system meant to be both extremely fast, and,
      even more importantly, as user friendly as possible.

      The main design point of Meson is that every moment a developer spends
      writing or debugging build definitions is a second wasted. So is every
      second spent waiting for the build system to actually start compiling
      code.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jtojnar mbe AndersonTorres ];
    inherit (python3.meta) platforms;
  };
}
# TODO: a more Nixpkgs-tailoired test suite
