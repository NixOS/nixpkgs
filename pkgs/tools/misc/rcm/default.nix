{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "rcm-${version}";
  version = "1.3.1";

  src = fetchurl {
    url = "https://thoughtbot.github.io/rcm/dist/rcm-${version}.tar.gz";
    sha256 = "9c8f92dba63ab9cb8a6b3d0ccf7ed8edf3f0fb388b044584d74778145fae7f8f";
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
