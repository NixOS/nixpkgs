{ lib, stdenv, fetchFromGitHub, fetchpatch, util-linux, ncurses, flex, bison }:

stdenv.mkDerivation rec {
  pname = "unnethack";
  version = "5.3.2";

  src = fetchFromGitHub {
    name = "UnNetHack";
    owner = "UnNetHack";
    repo = "UnNetHack";
    rev = version;
    sha256 = "1rg0mqyplgn3dfh3wz09a600qxk7aidqw4d84kyiincljvhyb7ps";
  };

  buildInputs = [ ncurses ];

  nativeBuildInputs = [ util-linux flex bison ];

  configureFlags = [ "--enable-curses-graphics"
                     "--disable-tty-graphics"
                     "--with-owner=no"
                     "--with-group=no"
                     "--with-gamesdir=/tmp/unnethack"
                   ];

  makeFlags = [ "GAMEPERM=744" ];
  patches = [
    # fix regression with bison, merged in master
    (fetchpatch {
      name = "fix-bison.patch";
      url = "https://github.com/UnNetHack/UnNetHack/commit/04f0a3a850a94eb8837ddcef31303968240d1c31.patch";
      sha256 = "1zblbwqqz9nx16k6n31wi2hdvz775lvzmkjblmrx18nbm4ylj0n9";
    })
  ];

  # Fails the build occasionally due to missing buid depends:
  #   ./../sys/unix/unixmain.c:9:10: fatal error: date.h: No such file or directory
  # TODO: remove once upstream issue is fixed:
  #   https://github.com/UnNetHack/UnNetHack/issues/56
  enableParallelBuilding = false;

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

  meta = with lib; {
    description = "Fork of NetHack";
    homepage = "https://unnethack.wordpress.com/";
    license = "nethack";
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
