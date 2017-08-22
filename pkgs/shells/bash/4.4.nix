{ stdenv, buildPackages
, fetchurl, readline70 ? null, texinfo ? null, binutils ? null, bison
, buildPlatform, hostPlatform
, interactive ? false
}:

assert interactive -> readline70 != null;
assert hostPlatform.isDarwin -> binutils != null;

let
  version = "4.4";
  realName = "bash-${version}";
  shortName = "bash44";
  sha256 = "1jyz6snd63xjn6skk7za6psgidsd53k05cr3lksqybi0q6936syq";

  upstreamPatches =
    let
      patch = nr: sha256:
        fetchurl {
          url = "mirror://gnu/bash/${realName}-patches/${shortName}-${nr}";
          inherit sha256;
        };
    in
      import ./bash-4.4-patches.nix patch;

  inherit (stdenv.lib) optional optionals optionalString;
in

stdenv.mkDerivation rec {
  name = "${realName}-p${toString (builtins.length upstreamPatches)}";

  src = fetchurl {
    url = "mirror://gnu/bash/${realName}.tar.gz";
    inherit sha256;
  };

  hardeningDisable = [ "format" ];

  outputs = [ "out" "dev" "doc" "info" ]
    # the man pages are small and useful enough, so include them in $out in interactive builds
    ++ stdenv.lib.optional (!interactive) "man";

  NIX_CFLAGS_COMPILE = ''
    -DSYS_BASHRC="/etc/bashrc"
    -DSYS_BASH_LOGOUT="/etc/bash_logout"
    -DDEFAULT_PATH_VALUE="/no-such-path"
    -DSTANDARD_UTILS_PATH="/no-such-path"
    -DNON_INTERACTIVE_LOGIN_SHELLS
    -DSSH_SOURCE_BASHRC
  '';

  patchFlags = "-p0";

  patches = upstreamPatches;

  postPatch = optionalString hostPlatform.isCygwin "patch -p2 < ${./cygwin-bash-4.4.11-2.src.patch}";

  configureFlags = [
    (if interactive then "--with-installed-readline" else "--disable-readline")
  ] ++ optionals (hostPlatform != buildPlatform) [
    "bash_cv_job_control_missing=nomissing bash_cv_sys_named_pipes=nomissing bash_cv_getcwd_malloc=yes"
  ] ++ optionals hostPlatform.isCygwin [
    "--without-libintl-prefix --without-libiconv-prefix"
    "--with-installed-readline"
    "bash_cv_dev_stdin=present"
    "bash_cv_dev_fd=standard"
    "bash_cv_termcap_lib=libncurses"
  ];

  # Note: Bison is needed because the patches above modify parse.y.
  nativeBuildInputs = [bison]
    ++ optional (texinfo != null) texinfo
    ++ optional hostPlatform.isDarwin binutils
    ++ optional (hostPlatform != buildPlatform) buildPackages.stdenv.cc;

  buildInputs = optional interactive readline70;

  # Bash randomly fails to build because of a recursive invocation to
  # build `version.h'.
  enableParallelBuilding = false;

  makeFlags = optional hostPlatform.isCygwin [
    "LOCAL_LDFLAGS=-Wl,--export-all,--out-implib,libbash.dll.a"
    "SHOBJ_LIBS=-lbash"
  ];

  postInstall = ''
    ln -s bash "$out/bin/sh"
    rm $out/lib/bash/Makefile.inc
  '';

  postFixup = if interactive
    then ''
      substituteInPlace "$out/bin/bashbug" \
        --replace '${stdenv.shell}' "$out/bin/bash"
    ''
    # most space is taken by locale data
    else ''
      rm -r "$out/share" "$out/bin/bashbug"
    '';

  meta = with stdenv.lib; {
    homepage = http://www.gnu.org/software/bash/;
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

    maintainers = [ maintainers.peti ];
  };

  passthru = {
    shellPath = "/bin/bash";
  };
}
