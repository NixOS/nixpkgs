args: with args;
stdenv.mkDerivation rec {
  name = "wvdial-1.61";

  src = fetchurl {
    url = "http://wvstreams.googlecode.com/files/${name}.tar.gz";
    sha256 = "0mzcrv8mc60gbdrixc9k8ammbslvjb9x2cs50yf1jq67aabapzsg";
  };

  buildInputs = [wvstreams pkgconfig];

  preConfigure = ''
    find -type f | xargs sed -i 's@/bin/bash@bash@g'
    export makeFlags="prefix=$out"
    # not sure about this line
    sed -i 's@/etc/ppp/peers@$out/etc/ppp/peers@' Makefile.in
  '';

  meta = {
    description = "dialer automatically recognizing the modem";
    homepage = http://alumnit.ca/wiki/index.php?page=WvDial;
    license = "LGPL";
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
