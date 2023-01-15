{ lib
, stdenv
, buildPackages
, fetchurl
, binutils
, bison
, util-linux

  # patch for cygwin requires readline support
, interactive ? stdenv.isCygwin
, readline
, withDocs ? false
, texinfo
, forFHSEnv ? false
}:

let
  upstreamPatches = import ./bash-5.2-patches.nix (nr: sha256: fetchurl {
    url = "mirror://gnu/bash/bash-5.2-patches/bash52-${nr}";
    inherit sha256;
  });
in
stdenv.mkDerivation rec {
  name = "bash-${lib.optionalString interactive "interactive-"}${version}-p${toString (builtins.length upstreamPatches)}";
  version = "5.2";

  src = fetchurl {
    url = "mirror://gnu/bash/bash-${version}.tar.gz";
    sha256 = "sha256-oTnBZt9/9EccXgczBRZC7lVWwcyKSnjxRVg8XIGrMvs=";
  };

  hardeningDisable = [ "format" ]
    # bionic libc is super weird and has issues with fortify outside of its own libc, check this comment:
    # https://github.com/NixOS/nixpkgs/pull/192630#discussion_r978985593
    # or you can check libc/include/sys/cdefs.h in bionic source code
    ++ lib.optional (stdenv.hostPlatform.libc == "bionic") "fortify";

  outputs = [ "out" "dev" "man" "doc" "info" ];

  NIX_CFLAGS_COMPILE = ''
    -DSYS_BASHRC="/etc/bashrc"
    -DSYS_BASH_LOGOUT="/etc/bash_logout"
  '' + lib.optionalString (!forFHSEnv) ''
    -DDEFAULT_PATH_VALUE="/no-such-path"
    -DSTANDARD_UTILS_PATH="/no-such-path"
  '' + ''
    -DNON_INTERACTIVE_LOGIN_SHELLS
    -DSSH_SOURCE_BASHRC
  '';

  patchFlags = [ "-p0" ];

  patches = upstreamPatches
    ++ [ ./pgrp-pipe-5.patch ]
    ++ lib.optional stdenv.hostPlatform.isStatic (fetchurl {
      name = "fix-static.patch";
      url = "https://cgit.freebsd.org/ports/plain/shells/bash/files/patch-configure?id=3e147a1f594751a68fea00a28090d0792bee0b51";
      sha256 = "XHFMQ6eXTReNoywdETyrfQEv1rKF8+XFbQZP4YoVKFk=";
    });

  configureFlags = [
    (if interactive then "--with-installed-readline" else "--disable-readline")
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "bash_cv_job_control_missing=nomissing"
    "bash_cv_sys_named_pipes=nomissing"
    "bash_cv_getcwd_malloc=yes"
  ] ++ lib.optionals stdenv.hostPlatform.isCygwin [
    "--without-libintl-prefix"
    "--without-libiconv-prefix"
    "--with-installed-readline"
    "bash_cv_dev_stdin=present"
    "bash_cv_dev_fd=standard"
    "bash_cv_termcap_lib=libncurses"
  ] ++ lib.optionals (stdenv.hostPlatform.libc == "musl") [
    "--without-bash-malloc"
    "--disable-nls"
  ];

  strictDeps = true;
  # Note: Bison is needed because the patches above modify parse.y.
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ bison ]
    ++ lib.optional withDocs texinfo
    ++ lib.optional stdenv.hostPlatform.isDarwin binutils;

  buildInputs = lib.optional interactive readline;

  enableParallelBuilding = true;

  makeFlags = lib.optionals stdenv.hostPlatform.isCygwin [
    "LOCAL_LDFLAGS=-Wl,--export-all,--out-implib,libbash.dll.a"
    "SHOBJ_LIBS=-lbash"
  ];

  checkInputs = [ util-linux ];
  doCheck = false; # dependency cycle, needs to be interactive

  postInstall = ''
    ln -s bash "$out/bin/sh"
    rm -f $out/lib/bash/Makefile.inc
  '';

  postFixup =
    if interactive
    then ''
      substituteInPlace "$out/bin/bashbug" \
        --replace '#!/bin/sh' "#!$out/bin/bash"
    ''
    # most space is taken by locale data
    else ''
      rm -rf "$out/share" "$out/bin/bashbug"
    '';

  passthru = {
    shellPath = "/bin/bash";
  };

  meta = with lib; {
    homepage = "https://www.gnu.org/software/bash/";
    description = "GNU Bourne-Again Shell, the de facto standard shell on Linux" + lib.optionalString interactive " (for interactive use)";
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
    maintainers = with maintainers; [ dtzWill ];
    mainProgram = "bash";
  };
}
