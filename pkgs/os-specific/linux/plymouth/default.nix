{ stdenv, fetchurl, cairo, gtk, libdrm, libpng, makeWrapper, pango, pkgconfig }:

stdenv.mkDerivation rec {
  name = "plymouth-${version}";
  version = "0.8.8";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/plymouth/releases/${name}.tar.bz2";
    sha256 = "16vm3llgci7h63jaclfskj1ii61d8psq7ny2mncml6m3sghs9b8v";
  };

  buildInputs = [ cairo gtk libdrm libpng makeWrapper pango pkgconfig ];

  configurePhase = ''
    export DESTDIR=$out
    ./configure \
      -bindir=$out/bin \
      -sbindir=$out/sbin \
      --prefix=$out \
      --exec-prefix=$out \
      --libdir=$out/lib \
      --libexecdir=$out/lib \
      --enable-tracing \
      --sysconfdir=/etc \
      --localstatedir=/var \
      --without-system-root-install \
      --enable-gtk
  '';
#      --enable-systemd-integration
#      -datadir=/share \
#      --with-rhgb-compat-link \

  preInstall = "mkdir -p $out/bin $out/sbin";

  postInstall = ''
    cd $out/$out
    mv bin/* $out/bin
    mv sbin/* $out/sbin

    rmdir bin
    rmdir sbin
    mv * $out/
    sed -e "s#> $output##" \
      -e "s#> /dev/stderr##" \
      -i $out/lib/plymouth/plymouth-populate-initrd
    wrapProgram $out/lib/plymouth/plymouth-populate-initrd \
      --set PATH $PATH:$out/bin:$out/sbin
  '';

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/Plymouth;
    description = "A graphical boot animation";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
