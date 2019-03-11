{ stdenv, fetchFromGitHub }:

# Although we copy in the udev rules here, you probably just want to use logitech-udev-rules instead of
# adding this to services.udev.packages on NixOS

stdenv.mkDerivation rec {
  name = "ltunify-${version}";
  version = "unstable-20180330";

  src = fetchFromGitHub {
    owner  = "Lekensteyn";
    repo   = "ltunify";
    rev    = "f664d1d41d5c4beeac5b81e485c3498f13109db7";
    sha256 = "07sqhih9jmm7vgiwqsjzihd307cj7l096sxjl25p7nwr1q4180wv";
  };

  makeFlags = [ "DESTDIR=$(out)" "bindir=/bin" ];

  meta = with stdenv.lib; {
    description = "Tool for working with Logitech Unifying receivers and devices";
    homepage = https://lekensteyn.nl/logitech-unifying.html;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
  };
}
