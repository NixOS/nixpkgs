{ stdenv, fetchFromGitHub, gcc, autoconf, automake, xorg, ... }:

stdenv.mkDerivation rec {
  name = "xjump-${version}";
  version = "2.9.3";
  src = fetchFromGitHub {
    owner = "hugomg";
    repo = "xjump";
    rev = "e7f20fb8c2c456bed70abb046c1a966462192b80";
    sha256 = "0hq4739cvi5a47pxdc0wwkj2lmlqbf1xigq0v85qs5bq3ixmq2f7";
  };
  buildInputs = [ gcc autoconf automake xorg.libX11 xorg.libXt xorg.libXpm xorg.libXaw ];
  preConfigure = ''
    autoreconf --install
  '';
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/xjump
    install -m 755 xjump $out/bin
    cp -R themes $out/share/xjump
  '';
  meta = with stdenv.lib; {
    description = "The falling tower game";
    maintainers = with maintainers; [ pmeunier ];
    platforms = platforms.linux;
  };
}
