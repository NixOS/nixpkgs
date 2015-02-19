{ stdenv, fetchurl, makeWrapper, utillinux, jre, jdk, opencv, tesseract, xdotool, wmctrl }:

stdenv.mkDerivation rec {
  name = "sikulix-${version}";
  version = "1.1.0.20140219";
  release = "1.1.0";

  ide = fetchurl {
    url = "http://nightly.sikuli.de/${release}-1.jar";
    sha256 = "0qvw2rvvw7vg5v8f202pwy0z8xxzzszsc2a7skihykjlf2fyjws8";
  };

  api = fetchurl {
    url = "http://nightly.sikuli.de/${release}-2.jar";
    sha256 = "15lhzm2gfqxzj88zrpw4hxi5avi22q4hw6r192zr67al6a21xhjm";
  };

  jython = fetchurl {
    url = "http://repo1.maven.org/maven2/org/python/jython-standalone/2.7-b3/jython-standalone-2.7-b3.jar";
    sha256 = "1nmcrx93g8krp7sjw1d31wwa3py1ix69mx6vdgidghi3djlpn3pw";
  };

  native = fetchurl {
    url = "http://nightly.sikuli.de/sikulixlibslux-${release}.jar";
    sha256 = "1ipwbwz1bylakl99r8b2rn74p15nfm45qmlhqmm9r5x3bls4h3v0";
  };

  setup = fetchurl {
    url = "http://nightly.sikuli.de/sikulixsetup-${release}.jar";
    sha256 = "0w8mc5yc5af482nrq661amgnwj6vwd5mvj9n4q6fn0w356gci669";
  };

  buildInputs = [ makeWrapper jre opencv tesseract xdotool wmctrl ];

  unpackPhase = "true";

  NIX_CFLAGS_COMPILE = "-ltesseract -lopencv_core -lopencv_highgui -lopencv_imgproc -I${jdk}/include";
  buildPhase = ''
    mkdir -p Downloads
    cp $ide Downloads/${release}-1.jar
    cp $api Downloads/${release}-2.jar
    cp $jython Downloads/jython-standalone-2.7-b3.jar
    cp $native Downloads/sikulixlibslux-${release}.jar
    cp $setup sikulixsetup-${release}.jar
    java -jar sikulixsetup-${release}.jar options 1.1
  '';

  installPhase = ''
    mkdir -p {bin,$out/libexec/sikulix}
    cp -R libs sikulix.jar runsikulix $out/libexec/sikulix
    makeWrapper $out/libexec/sikulix/runsikulix $out/bin/sikulix \
      --prefix PATH : "${jre}/bin:${xdotool}/bin:${wmctrl}/bin"
  '';

  meta = with stdenv.lib; {
    description = "Sikuli automates anything you see on the screen.";
    homepage = http://www.sikulix.com/;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ offline ];
    platforms = with platforms; linux;
  };
}
