args: with args;
stdenv.mkDerivation {
  name = "gftp-2.0.18";

  src = fetchurl {
    url = http://www.gftp.org/gftp-2.0.18.tar.bz2;
    sha256 = "8145e18d1edf13e8cb6cd7a69bb69de5c46307086997755654488fb8282d38a2";
  };

  buildInputs = [ gtk readline ncurses gettext openssl pkgconfig ];

  meta = { 
      description = "GTK based FTP client";
      homepage = http://www.gftp.org;
      license = "GPL";
  };
}
