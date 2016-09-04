{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "rcm-1.3.0";

  src = fetchurl {
    url = https://thoughtbot.github.io/rcm/dist/rcm-1.3.0.tar.gz;
    sha256 = "ddcf638b367b0361d8e063c29fd573dbe1712d1b83e8d5b3a868e4aa45ffc847";
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
    platforms = with platforms; unix;
  };
}
