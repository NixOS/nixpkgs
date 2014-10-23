{ stdenv, fetchurl, readline ? null, interactive ? false, texinfo ? null, bison }:

assert interactive -> readline != null;

let
  version = if stdenv.isCygwin then "4.1" else "4.3";
  realName = "bash-${version}";
  shortName = if stdenv.isCygwin then "bash41" else "bash43";
  baseConfigureFlags = if interactive then "--with-installed-readline" else "--disable-readline";
  sha256 = if version == "4.1" then
      "1np1ggp1lv8idwfx3mcxl9rhadqdf4h3x4isa3dk8v9wm0j72qiz"
    else
      "1m14s1f61mf6bijfibcjm9y6pkyvz6gibyl8p4hxq90fisi8gimg";

  basePatchFun = if version == "4.1" then
      ./bash-4.1-patches.nix
    else
      ./bash-4.3-patches.nix;

  extraPatches = stdenv.lib.optional stdenv.isCygwin ./bash-4.1.17-9.src.patch;
in

stdenv.mkDerivation rec {
  name = "${realName}-p${toString (builtins.length patches)}";

  src = fetchurl {
    url = "mirror://gnu/bash/${realName}.tar.gz";
    inherit sha256;
  };

  NIX_CFLAGS_COMPILE = ''
    -DSYS_BASHRC="/etc/bashrc"
    -DSYS_BASH_LOGOUT="/etc/bash_logout"
    -DDEFAULT_PATH_VALUE="/no-such-path"
    -DSTANDARD_UTILS_PATH="/no-such-path"
    -DNON_INTERACTIVE_LOGIN_SHELLS
    -DSSH_SOURCE_BASHRC
  '';

  patchFlags = "-p0";

  patches =
    (let
      patch = nr: sha256:
        fetchurl {
          url = "mirror://gnu/bash/${realName}-patches/${shortName}-${nr}";
          inherit sha256;
        };
    in
      import basePatchFun patch) ++ extraPatches;

  crossAttrs = {
    configureFlags = baseConfigureFlags +
      " bash_cv_job_control_missing=nomissing bash_cv_sys_named_pipes=nomissing";
  };

  configureFlags = baseConfigureFlags;

  # Note: Bison is needed because the patches above modify parse.y.
  nativeBuildInputs = [bison]
    ++ stdenv.lib.optional (texinfo != null) texinfo
    ++ stdenv.lib.optional interactive readline;

  # Bash randomly fails to build because of a recursive invocation to
  # build `version.h'.
  enableParallelBuilding = false;

  postInstall = ''
    # Add an `sh' -> `bash' symlink.
    ln -s bash "$out/bin/sh"
  '';

  meta = {
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

    license = stdenv.lib.licenses.gpl3Plus;

    platforms = stdenv.lib.platforms.all;

    maintainers = [ stdenv.lib.maintainers.simons ];
  };

  passthru = {
    shellPath = "/bin/bash";
  };
}
