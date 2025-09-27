{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  updateAutotoolsGnuConfigScriptsHook,
  bison,
  util-linux,

  interactive ? true,
  readline,
  withDocs ? null,
  forFHSEnv ? false,

  pkgsStatic,
}:

let
  upstreamPatches = import ./bash-5.3-patches.nix (
    nr: sha256:
    fetchurl {
      url = "mirror://gnu/bash/bash-5.3-patches/bash53-${nr}";
      inherit sha256;
    }
  );
in
lib.warnIf (withDocs != null)
  ''
    bash: `.override { withDocs = true; }` is deprecated, the docs are always included.
  ''
  stdenv.mkDerivation
  rec {
    pname = "bash${lib.optionalString interactive "-interactive"}";
    version = "5.3${patch_suffix}";
    patch_suffix = "p${toString (builtins.length upstreamPatches)}";

    src = fetchurl {
      url = "mirror://gnu/bash/bash-${lib.removeSuffix patch_suffix version}.tar.gz";
      hash = "sha256-DVzYaWX4aaJs9k9Lcb57lvkKO6iz104n6OnZ1VUPMbo=";
    };

    hardeningDisable = [
      "format"
    ]
    # bionic libc is super weird and has issues with fortify outside of its own libc, check this comment:
    # https://github.com/NixOS/nixpkgs/pull/192630#discussion_r978985593
    # or you can check libc/include/sys/cdefs.h in bionic source code
    ++ lib.optional (stdenv.hostPlatform.libc == "bionic") "fortify";

    outputs = [
      "out"
      "dev"
      "man"
      "doc"
      "info"
    ];

    separateDebugInfo = true;

    env.NIX_CFLAGS_COMPILE = ''
      -DSYS_BASHRC="/etc/bashrc"
      -DSYS_BASH_LOGOUT="/etc/bash_logout"
    ''
    + lib.optionalString (!forFHSEnv) ''
      -DDEFAULT_PATH_VALUE="/no-such-path"
      -DSTANDARD_UTILS_PATH="/no-such-path"
      -DDEFAULT_LOADABLE_BUILTINS_PATH="${placeholder "out"}/lib/bash:."
    ''
    + ''
      -DNON_INTERACTIVE_LOGIN_SHELLS
      -DSSH_SOURCE_BASHRC
    '';

    patchFlags = [ "-p0" ];

    patches = upstreamPatches ++ [
      # Enable PGRP_PIPE independently of the kernel of the build machine.
      # This doesn't seem to be upstreamed despite such a mention of in https://github.com/NixOS/nixpkgs/pull/77196,
      # which originally introduced the patch
      # Some related discussion can be found in
      # https://lists.gnu.org/archive/html/bug-bash/2015-05/msg00071.html
      ./pgrp-pipe-5.patch
    ];

    configureFlags = [
      # At least on Linux bash memory allocator has pathological performance
      # in scenarios involving use of larger memory:
      #   https://lists.gnu.org/archive/html/bug-bash/2023-08/msg00052.html
      # Various distributions default to system allocator. Let's nixpkgs
      # do the same.
      "--without-bash-malloc"
      (if interactive then "--with-installed-readline" else "--disable-readline")
    ]
    ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      "bash_cv_job_control_missing=nomissing"
      "bash_cv_sys_named_pipes=nomissing"
      "bash_cv_getcwd_malloc=yes"
      # This check cannot be performed when cross compiling. The "yes"
      # default is fine for static linking on Linux (weak symbols?) but
      # not with BSDs, when it does clash with the regular `getenv`.
      "bash_cv_getenv_redef=${
        if !(with stdenv.hostPlatform; isStatic && (isOpenBSD || isFreeBSD)) then "yes" else "no"
      }"
    ]
    ++ lib.optionals stdenv.hostPlatform.isCygwin [
      "--without-libintl-prefix"
      "--without-libiconv-prefix"
      "--with-installed-readline"
      "bash_cv_dev_stdin=present"
      "bash_cv_dev_fd=standard"
      "bash_cv_termcap_lib=libncurses"
    ]
    ++ lib.optionals (stdenv.hostPlatform.libc == "musl") [
      "--disable-nls"
    ]
    ++ lib.optionals stdenv.hostPlatform.isFreeBSD [
      # /dev/fd is optional on FreeBSD. we need it to work when built on a system
      # with it and transferred to a system without it! This includes linux cross.
      "bash_cv_dev_fd=absent"
    ];

    strictDeps = true;
    # Note: Bison is needed because the patches above modify parse.y.
    depsBuildBuild = [ buildPackages.stdenv.cc ];
    nativeBuildInputs = [
      updateAutotoolsGnuConfigScriptsHook
      bison
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin stdenv.cc.bintools;

    buildInputs = lib.optional interactive readline;

    enableParallelBuilding = true;

    makeFlags = lib.optionals stdenv.hostPlatform.isCygwin [
      "LOCAL_LDFLAGS=-Wl,--export-all,--out-implib,libbash.dll.a"
      "SHOBJ_LIBS=-lbash"
    ];

    nativeCheckInputs = [ util-linux ];
    doCheck = false; # dependency cycle, needs to be interactive

    postInstall = ''
      ln -s bash "$out/bin/sh"
      rm -f $out/lib/bash/Makefile.inc
    '';

    postFixup =
      if interactive then
        ''
          substituteInPlace "$out/bin/bashbug" \
            --replace '#!/bin/sh' "#!$out/bin/bash"
        ''
      # most space is taken by locale data
      else
        ''
          rm -rf "$out/share" "$out/bin/bashbug"
        '';

    passthru = {
      shellPath = "/bin/bash";
      tests.static = pkgsStatic.bash;
    };

    meta = with lib; {
      homepage = "https://www.gnu.org/software/bash/";
      description =
        "GNU Bourne-Again Shell, the de facto standard shell on Linux"
        + lib.optionalString interactive " (for interactive use)";
      longDescription = ''
        Bash is the shell, or command language interpreter, that will
        appear in the GNU operating system.  Bash is an sh-compatible
        shell that incorporates useful features from the Korn shell
        (ksh) and C shell (csh).  It is intended to conform to the IEEE
        POSIX P1003.2/ISO 9945.2 Shell and Tools standard.  It offers
        functional improvements over sh for both programming and
        interactive use.  In addition, most sh scripts can be run by
        Bash without modification.
      '';
      license = licenses.gpl3Plus;
      platforms = platforms.all;
      # https://github.com/NixOS/nixpkgs/issues/333338
      badPlatforms = [ lib.systems.inspect.patterns.isMinGW ];
      maintainers = [ ];
      mainProgram = "bash";
      identifiers.cpeParts =
        let
          versionSplit = lib.split "p" version;
        in
        {
          vendor = "gnu";
          product = "bash";
          version = lib.elemAt versionSplit 0;
          update = lib.elemAt versionSplit 2;
        };
    };
  }
