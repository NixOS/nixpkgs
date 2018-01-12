{ stdenv, fetchurl, cairo, fontconfig, freetype, gdk_pixbuf, glib
, glibc, gtk2, libX11, makeWrapper, nspr, nss, pango, unzip, gconf
, libXi, libXrender, libXext
}:
let
  allSpecs = {
    "i686-linux" = {
      system = "linux32";
      sha256 = "13fngjg2v0l3vhlmjnffy785ckgk2kbpm7307li75vinkcly91cj";
    };

    "x86_64-linux" = {
      system = "linux64";
      sha256 = "0x5vnmnw6mws6iw9s0kcm4crx9gfgy0vjjpk1v0wk7jpn6d0bl47";
    };

    "x86_64-darwin" = {
      system = "mac64";
      sha256 = "09y8ijj75q5a7snzchxinxfq2ad2sw0f30zi0p3hqf1n88y28jq6";
    };
  };

  spec = allSpecs."${stdenv.system}"
    or (throw "missing chromedriver binary for ${stdenv.system}");

  libs = stdenv.lib.makeLibraryPath [
    stdenv.cc.cc.lib
    cairo fontconfig freetype
    gdk_pixbuf glib gtk2 gconf
    libX11 nspr nss pango libXrender
    gconf libXext libXi
  ];
in
stdenv.mkDerivation rec {
  name = "chromedriver-${version}";
  version = "2.33";

  src = fetchurl {
    url = "http://chromedriver.storage.googleapis.com/${version}/chromedriver_${spec.system}.zip";
    sha256 = spec.sha256;
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  unpackPhase = "unzip $src";

  installPhase = ''
    install -m755 -D chromedriver $out/bin/chromedriver
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    patchelf --set-interpreter ${glibc.out}/lib/ld-linux-x86-64.so.2 $out/bin/chromedriver
    wrapProgram "$out/bin/chromedriver" --prefix LD_LIBRARY_PATH : "${libs}:\$LD_LIBRARY_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://sites.google.com/a/chromium.org/chromedriver;
    description = "A WebDriver server for running Selenium tests on Chrome";
    license = licenses.bsd3;
    maintainers = [ maintainers.goibhniu ];
    platforms = attrNames allSpecs;
  };
}
