{stdenv, fetchurl, bison, interactive ? false, ncurses ? null, texinfo ? null, readline ? null}:

assert interactive -> ncurses != null;
assert interactive -> readline != null;

stdenv.mkDerivation {
  name = "bash-4.0";

  src = fetchurl {
    url = mirror://gnu/bash/bash-4.0.tar.gz;
    sha256 = "9793d394f640a95030c77d5ac989724afe196921956db741bcaf141801c50518";
  };

  NIX_CFLAGS_COMPILE = ''
    -DSYS_BASHRC="/etc/bashrc"
    -DSYS_BASH_LOGOUT="/etc/bash_logout"
    -DDEFAULT_PATH_VALUE="/no-such-path"
    -DSTANDARD_UTILS_PATH="/no-such-path"
    -DNON_INTERACTIVE_LOGIN_SHELLS
    -DSSH_SOURCE_BASHRC
  '';

  postInstall = "ln -s bash $out/bin/sh";

  patches = [
    # For dietlibc builds.
    ./winsize.patch
  ];

  configureFlags = if interactive then "--enable-readline --with-installed-readline" else "";

  # !!! Bison is only needed for bash-3.2 (because of bash32-001.patch)
  buildInputs = [bison]
    ++ stdenv.lib.optional (texinfo != null) texinfo
    ++ stdenv.lib.optional interactive readline
    ++ stdenv.lib.optional interactive ncurses;

  meta = {
    homepage = http://www.gnu.org/software/bash/;
    description =
      "GNU Bourne-Again Shell, the de facto standard shell on Linux" +
        (if interactive then " (for interactive use)" else "");
  };
}
