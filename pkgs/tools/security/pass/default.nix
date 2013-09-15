{ stdenv, fetchurl, getopt }:

stdenv.mkDerivation rec {
  version = "1.4.2";
  name    = "password-store-${version}";

  src = fetchurl {
    url    = "http://git.zx2c4.com/password-store/snapshot/${name}.tar.xz";
    sha256 = "00m3q6dihrhw8cxsrham3bdqg5841an8ch4s3a4k5fynlcb802m1";
  };

  meta = with stdenv.lib; {
    description = "Stores, retrieves, generates, and synchronizes passwords securely.";
    homepage    = http://zx2c4.com/projects/password-store/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;

    longDescription = ''
      pass is a very simple password store that keeps passwords inside gpg2
      encrypted files inside a simple directory tree residing at
      ~/.password-store. The pass utility provides a series of commands for
      manipulating the password store, allowing the user to add, remove, edit,
      synchronize, generate, and manipulate passwords.
    '';
  };

  propagatedBuildInputs = [ getopt ];

  installPhase = ''
    # link zsh and fish completions
    sed -ie '22s/^#//' Makefile
    sed -ie '25s/^#//' Makefile
    sed -i 's/find /find -L /' contrib/pass.zsh-completion
    mkdir -p "$out/share/zsh/site-functions"
    mkdir -p "$out/share/fish/completions"

    # use gnused
    sed -i 's/sed -i ""/sed -i /' Makefile

    SYSCONFDIR="$out/etc" PREFIX="$out" make install
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    # use nix-supplied getopt
    sed -ie '34c GETOPT="${getopt}/bin/getopt"' \
      "$out/lib/password-store.platform.sh"
  '';
}

