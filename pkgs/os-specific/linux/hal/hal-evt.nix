args: with args;
stdenv.mkDerivation {
  name = "hal-evt-0.1.4";

  src = fetchurl {
    url = http://savannah.nongnu.org/download/halevt/halevt-0.1.4.tar.gz;
    sha256 = "173dphyzpicjz5pnw0d6wmibvib5h99nh1gmyvcqpgvf8la5vrps";
  };

  buildInputs = [libxml2 pkgconfig boolstuff hal dbus_glib];

  meta = { 
    description = "execute commands on hal events";
    homepage = http://www.nongnu.org/halevt/;
    license = "GPLv2";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
