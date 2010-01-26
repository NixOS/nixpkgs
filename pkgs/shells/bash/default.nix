{stdenv, fetchurl, readline ? null, interactive ? false, texinfo ? null, bison}:

assert interactive -> readline != null;

let realName = "bash-4.1"; in
stdenv.mkDerivation rec {
  name = "${realName}-p${builtins.length patches}";

  src = fetchurl {
    url = "mirror://gnu/bash/${realName}.tar.gz";
    sha256 = "1np1ggp1lv8idwfx3mcxl9rhadqdf4h3x4isa3dk8v9wm0j72qiz";
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
    let
      patch = nr: sha256:
        fetchurl {
          url = "mirror://gnu/bash/bash-4.1-patches/bash41-${nr}";
          inherit sha256;
        };
    in
      import ./bash-patches.nix patch;

  # Note: Bison is needed because the patches above modify parse.y.
  buildNativeInputs = [bison];
  buildInputs = stdenv.lib.optional (texinfo != null) texinfo
    ++ stdenv.lib.optional interactive readline;

  configureFlags = if interactive then "--with-installed-readline" else "--disable-readline";
   
  postInstall = ''
    # Add an `sh' -> `bash' symlink.
    ln -s bash "$out/bin/sh"

    # Install the completion examples.
    ensureDir "$out/etc"
    cp -v "examples/complete/bash_completion" "$out/etc"

    ensureDir "$out/etc/bash_completion.d"
    cp -v "examples/complete/complete.gnu-longopt" "$out/etc/bash_completion.d"
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

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
