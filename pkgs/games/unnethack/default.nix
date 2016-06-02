{ stdenv, fetchgit, utillinux, ncurses, flex, bison }:

stdenv.mkDerivation rec {
  name = "unnethack-5.3.1";

  src = fetchgit {
    url = "https://github.com/UnNetHack/UnNetHack";
    rev = "63677eb256b5a75430f190cfb0f76bdd9bd0b9dd";
    sha256 = "0w6vyg0j2xdvr5vdlyf3dwliyxjzcr5fdbx5maygxiql44j104v3";
  };

  buildInputs = [ ncurses ];

  nativeBuildInputs = [ utillinux flex bison ];

  configureFlags = [ "--enable-curses-graphics"
                     "--disable-tty-graphics"
                     "--with-owner=no"
                     "--with-group=no"
                     "--with-gamesdir=/tmp/unnethack"
                   ];

  postInstall = ''
    cp -r /tmp/unnethack $out/share/unnethack/profile
    mv $out/bin/unnethack $out/bin/.wrapped_unnethack
    cat <<EOF >$out/bin/unnethack
      #! ${stdenv.shell} -e
      if [ ! -d ~/.unnethack ]; then
        mkdir -p ~/.unnethack
        cp -r $out/share/unnethack/profile/* ~/.unnethack
        chmod -R +w ~/.unnethack
      fi

      ln -s ~/.unnethack /tmp/unnethack

      cleanup() {
        rm -rf /tmp/unnethack
      }
      trap cleanup EXIT

      $out/bin/.wrapped_unnethack
    EOF
    chmod +x $out/bin/unnethack
  '';

  meta = with stdenv.lib; {
    description = "Fork of NetHack";
    homepage = "http://unnethack.wordpress.com/";
    license = "nethack";
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  }; 
}
