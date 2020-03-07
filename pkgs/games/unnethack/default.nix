{ stdenv, fetchgit, utillinux, ncurses, flex, bison }:

stdenv.mkDerivation rec {
  pname = "unnethack";
  version = "5.2.0";

  src = fetchgit {
    url = "https://github.com/UnNetHack/UnNetHack";
    rev = "refs/tags/${version}";
    sha256 = "088gd2c7v95f2pm9ky38i28sz73mnsksr2p2hhhflkchxncd21f1";
  };

  buildInputs = [ ncurses ];

  nativeBuildInputs = [ utillinux flex bison ];

  configureFlags = [ "--enable-curses-graphics"
                     "--disable-tty-graphics"
                     "--with-owner=no"
                     "--with-group=no"
                     "--with-gamesdir=/tmp/unnethack"
                   ];

  makeFlags = [ "GAMEPERM=744" ];

  enableParallelBuilding = true;

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
    homepage = https://unnethack.wordpress.com/;
    license = "nethack";
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  }; 
}
