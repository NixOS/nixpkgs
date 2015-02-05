{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "rcm-1.2.3";

  src = fetchurl {
    url = https://thoughtbot.github.io/rcm/dist/rcm-1.2.3.tar.gz;
    sha256 = "0gwpclbc152jkclj3w83s2snx3dcgljwr75q1z8czl3yar7d8bsh";
  };
 
  patches = [ ./fix-rcmlib-path.patch ];

  postPatch = ''
    for f in bin/*.in; do
      substituteInPlace $f --subst-var-by rcm $out
    done
  '';

  meta = with stdenv.lib; {
    description = "Management Suite for Dotfiles";
    homepage = https://github.com/thoughtbot/rcm;
    license = licenses.bsd3;
    maintainers = with maintainers; [ malyn ];
  };
}
