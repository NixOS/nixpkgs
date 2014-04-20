{ stdenv, fetchurl, cairo, fontconfig, freetype, gdk_pixbuf, glib
, glibc, gtk, libX11, makeWrapper, nspr, nss, pango, unzip, gconf
, libXi, libXrender, libXext
}:

# note: there is a i686 version available as well
assert stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name = "chromedriver_linux64";

  src = fetchurl {
    url = "http://chromedriver.storage.googleapis.com/2.9/${name}.zip";
    sha256 = "1m5xl5pz445igvhj31hby97xbizlw05b8fc6w53zq7faw7mzm665";
  };

  buildInputs = [ unzip makeWrapper ];

  unpackPhase = "unzip $src";

  installPhase = ''
    mkdir -p $out/bin
    mv chromedriver $out/bin
    patchelf --set-interpreter ${glibc}/lib/ld-linux-x86-64.so.2 $out/bin/chromedriver
    wrapProgram "$out/bin/chromedriver" \
      --prefix LD_LIBRARY_PATH : "$(cat ${stdenv.gcc}/nix-support/orig-gcc)/lib64:${cairo}/lib:${fontconfig}/lib:${freetype}/lib:${gdk_pixbuf}/lib:${glib}/lib:${gtk}/lib:${libX11}/lib:${nspr}/lib:${nss}/lib:${pango}/lib:${libXrender}/lib:${gconf}/lib:${libXext}/lib:${libXi}/lib:\$LD_LIBRARY_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/chromedriver/;
    description = "A WebDriver server for running Selenium tests on Chrome";
    license = licenses.bsd3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
