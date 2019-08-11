{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "uucp-1.07";

  src = fetchurl {
    url = "mirror://gnu/uucp/${name}.tar.gz";
    sha256 = "0b5nhl9vvif1w3wdipjsk8ckw49jj1w85xw1mmqi3zbcpazia306";
  };

  hardeningDisable = [ "format" ];

  prePatch = ''
    # do not set sticky bit in nix store
    substituteInPlace Makefile.in \
      --replace 4555 0555
    sed -i '/chown $(OWNER)/d' Makefile.in
  '';

  meta = {
    description = "Unix-unix cp over serial line, also includes cu program";

    longDescription =
      '' Taylor UUCP is a free implementation of UUCP and is the standard
         UUCP used on the GNU system.  If you don't know what UUCP is chances
         are, nowadays, that you won't need it.  If you do need it, you've
         just found one of the finest UUCP implementations available.
      '';

    homepage = https://www.gnu.org/software/uucp/uucp.html;

    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
