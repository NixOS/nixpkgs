{ lib, stdenv, fetchurl, alsa-lib, libjack2, CoreAudio, ncurses, pkg-config }:

stdenv.mkDerivation rec {
  pname = "timidity";
  version = "2.15.0";

  src = fetchurl {
    url = "mirror://sourceforge/timidity/TiMidity++-${version}.tar.bz2";
    sha256 = "1xf8n6dqzvi6nr2asags12ijbj1lwk1hgl3s27vm2szib8ww07qn";
  };

  patches = [ ./timidity-iA-Oj.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libjack2
    ncurses
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
  ] ++ lib.optionals stdenv.isDarwin [
    CoreAudio
  ];

  configureFlags = [
    "--enable-ncurses"
  ] ++ lib.optionals stdenv.isLinux [
    "--enable-audio=oss,alsa,jack"
    "--enable-alsaseq"
    "--with-default-output=alsa"
  ] ++ lib.optionals stdenv.isDarwin [
    "--enable-audio=darwin,jack"
  ];

  NIX_LDFLAGS = "-ljack -L${libjack2}/lib";

  instruments = fetchurl {
    url = "http://www.csee.umbc.edu/pub/midia/instruments.tar.gz";
    sha256 = "0lsh9l8l5h46z0y8ybsjd4pf6c22n33jsjvapfv3rjlfnasnqw67";
  };

  # the instruments could be compressed (?)
  postInstall = ''
    mkdir -p $out/share/timidity/;
    cp ${./timidity.cfg} $out/share/timidity/timidity.cfg
    tar --strip-components=1 -xf $instruments -C $out/share/timidity/
  '';
  # This fixup step is unnecessary and fails on Darwin
  dontRewriteSymlinks = stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/timidity/";
    license = licenses.gpl2;
    description = "A software MIDI renderer";
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.unix;
  };
}
