{ stdenv
, buildPackages
, fetchurl
, binutils ? null
, bison
, util-linux

  # patch for cygwin requires readline support
, interactive ? stdenv.isCygwin
, readline80 ? null
, withDocs ? false
, texinfo ? null
}:

with stdenv.lib;

assert interactive -> readline80 != null;
assert withDocs -> texinfo != null;
assert stdenv.hostPlatform.isDarwin -> binutils != null;
let
  upstreamPatches = import ./bash-5.1-patches.nix (nr: sha256: fetchurl {
    url = "mirror://gnu/bash/bash-5.1-patches/bash51-${nr}";
    inherit sha256;
  });
in
stdenv.mkDerivation rec {
  name = "bash-${optionalString interactive "interactive-"}${version}-p${toString (builtins.length upstreamPatches)}";
  version = "5.1";

  src = fetchurl {
    url = "mirror://gnu/bash/bash-${version}.tar.gz";
    sha256 = "1alv68wplnfdm6mh39hm57060xgssb9vqca4yr1cyva0c342n0fc";
  };

  hardeningDisable = [ "format" ];

  outputs = [ "out" "dev" "man" "doc" "info" ];

  NIX_CFLAGS_COMPILE = ''
    -DSYS_BASHRC="/etc/bashrc"
    -DSYS_BASH_LOGOUT="/etc/bash_logout"
    -DDEFAULT_PATH_VALUE="/no-such-path"
    -DSTANDARD_UTILS_PATH="/no-such-path"
    -DNON_INTERACTIVE_LOGIN_SHELLS
    -DSSH_SOURCE_BASHRC
  '';

  patchFlags = [ "-p0" "-T" ];

  patches = upstreamPatches
    ++ [ ./pgrp-pipe-5.1.patch ];

  configureFlags = [
    (if interactive then "--with-installed-readline" else "--disable-readline")
  ] ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "bash_cv_job_control_missing=nomissing"
    "bash_cv_sys_named_pipes=nomissing"
    "bash_cv_getcwd_malloc=yes"
  ] ++ optionals stdenv.hostPlatform.isCygwin [
    "--without-libintl-prefix"
    "--without-libiconv-prefix"
    "--with-installed-readline"
    "bash_cv_dev_stdin=present"
    "bash_cv_dev_fd=standard"
    "bash_cv_termcap_lib=libncurses"
  ] ++ optionals (stdenv.hostPlatform.libc == "musl") [
    "--without-bash-malloc"
    "--disable-nls"
  ];

  # Note: Bison is needed because the patches above modify parse.y.
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ bison ]
    ++ optional withDocs texinfo
    ++ optional stdenv.hostPlatform.isDarwin binutils;

  buildInputs = optional interactive readline80;

  enableParallelBuilding = true;

  makeFlags = optional stdenv.hostPlatform.isCygwin [
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
        --replace '${stdenv.shell}' "$out/bin/bash"
    ''
    # most space is taken by locale data
    else ''
      rm -rf "$out/share" "$out/bin/bashbug"
    '';

  meta = with stdenv.lib; {
    homepage = "https://www.gnu.org/software/bash/";
    description =
      "GNU Bourne-Again Shell, the de facto standard shell on Linux" +
      (if interactive then " (for interactive use)" else "");

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

    maintainers = with maintainers; [ peti dtzWill ];
  };

  passthru = {
    shellPath = "/bin/bash";
  };
}
