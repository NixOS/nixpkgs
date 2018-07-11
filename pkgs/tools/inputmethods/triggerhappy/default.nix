{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "triggerhappy-${version}";
  version = "0.5.0";

  src = fetchurl {
    url = "https://github.com/wertarbyte/triggerhappy/archive/release/${version}.tar.gz";
    sha256 = "af0fc196202f2d35153be401769a9ad9107b5b6387146cfa8895ae9cafad631c";
  };

  buildInputs = [ perl ];
  installFlags = [ "DESTDIR=$(out)" ];  

  postPatch = ''
    substituteInPlace Makefile --replace "/usr/" "/"
    substituteInPlace Makefile --replace "/sbin/" "/bin/"
  '';

  postInstall = ''
    install -D -m 644 -t "$out/etc/triggerhappy/triggers.d" "triggerhappy.conf.examples"
    install -D -m 644 -t "$out/usr/lib/systemd/system" "systemd/triggerhappy.service" "systemd/triggerhappy.socket"
    install -D -m 644 -t "$out/usr/lib/udev/rules.d" "udev/triggerhappy-udev.rules"
  '';

  meta = with stdenv.lib; {
    description = "A lightweight hotkey daemon";
    longDescription = ''
      Triggerhappy is a hotkey daemon developed with small and embedded systems in
      mind, e.g. linux based routers. It attaches to the input device files and
      interprets the event data received and executes scripts configured in its
      configuration.
    '';
    homepage = https://github.com/wertarbyte/triggerhappy/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.taha ];
  };
}
