{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "glulxe";
  version = "0.5.4";

  buildInputs = [ ncurses ]; 

  srcs = [
    (fetchurl {
      url = "https://eblong.com/zarf/glulx/glulxe-054.tar.gz";
      sha256 = "0vipydg6ra90yf9b3ipgppwxyb2xdhcxwvirgjy0v20wlf56zhhz";
    })
    (fetchurl {
      url = "https://eblong.com/zarf/glk/glkterm-104.tar.gz";
      sha256 = "0zlj9nlnkdlvgbiliczinirqygiq8ikg5hzh5vgcmnpg9pvnwga7";
    })
  ];

  sourceRoot = "glulxe";

  configurePhase = ''
  substituteInPlace Makefile \
    --replace "#GLKINCLUDEDIR = ../glkterm" "GLKINCLUDEDIR = ../glkterm" \
    --replace "#GLKLIBDIR = ../glkterm" "GLKLIBDIR = ../glkterm" \
    --replace "#GLKMAKEFILE = Make.glkterm" "GLKMAKEFILE = Make.glkterm"

    cd ../glkterm
    make
    cd ../glulxe
  '';

  installPhase = ''
    install -Dm755 glulxe $out/bin/glulxe
  '';

  meta = with stdenv.lib; {
    description = "Interpreter for a 32-bit portable virtual machine intended for playing interactive fiction, relieving some of the restrictions in the venerable Z-machine format";
    license = licenses.mit;
    maintainers = with maintainers; [ kisonecat ];
    homepage = http://eblong.com/zarf/glulx/;
  };
}
