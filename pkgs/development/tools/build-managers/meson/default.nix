{ lib
, stdenv
, fetchPypi
, fetchpatch
, installShellFiles
, ninja
, pkg-config
, python3
, zlib
, coreutils
, substituteAll
, Foundation
, OpenGL
, AppKit
, Cocoa
, libxcrypt
}:

python3.pkgs.buildPythonApplication rec {
  pname = "meson";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0EtUH5fKQ5+4L6t9DUgJiL5L1OYlY6XKNfrbVAByexw=";
  };

  patches = [
    # Fix Meson tests that fail when the Nix store is case-sensitive APFS.
    # https://github.com/mesonbuild/meson/pull/11820
    ./darwin-case-sensitive-fs.patch

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

    # Nixpkgs cctools does not have bitcode support.
    ./disable-bitcode.patch

    # Fix passing multiple --define-variable arguments to pkg-config.
    # https://github.com/mesonbuild/meson/pull/10670
    (fetchpatch {
      url = "https://github.com/mesonbuild/meson/commit/d5252c5d4cf1c1931fef0c1c98dd66c000891d21.patch";
      sha256 = "GiUNVul1N5Fl8mfqM7vA/r1FdKqImiDYLXMVDt77gvw=";
      excludes = [
        "docs/yaml/objects/dep.yaml"
      ];
    })
  ];

  setupHook = ./setup-hook.sh;

  nativeCheckInputs = [ ninja pkg-config ];
  checkInputs = [ zlib ]
    ++ lib.optionals stdenv.isDarwin [ Foundation OpenGL AppKit Cocoa ];
  checkPhase = ''
    runHook preCheck

    patchShebangs 'test cases'
    substituteInPlace 'test cases/native/8 external program shebang parsing/script.int.in' \
      --replace /usr/bin/env ${coreutils}/bin/env
    # requires git, creating cyclic dependency
    rm -r 'test cases/common/66 vcstag'
    # requires glib, creating cyclic dependency
    rm -r 'test cases/linuxlike/6 subdir include order'
    rm -r 'test cases/linuxlike/9 compiler checks with dependencies'
    # requires static zlib, see #66461
    rm -r 'test cases/linuxlike/14 static dynamic linkage'
    # Nixpkgs cctools does not have bitcode support.
    rm -r 'test cases/osx/7 bitcode'
    HOME="$TMPDIR" python ./run_project_tests.py

    runHook postCheck
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

    substituteInPlace "$out/share/bash-completion/completions/meson" \
      --replace "python3 -c " "${python3.interpreter} -c "
  '';

  buildInputs = lib.optionals (python3.pythonOlder "3.9") [
    libxcrypt
  ];

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
    maintainers = with maintainers; [ mbe AndersonTorres ];
    inherit (python3.meta) platforms;
  };
}
# TODO: a more Nixpkgs-tailoired test suite
