{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "rcm-${version}";
  version = "1.3.3";

  src = fetchurl {
    url = "https://thoughtbot.github.io/rcm/dist/rcm-${version}.tar.gz";
    sha256 = "1bqk7rrp1ckzvsvl9wghsr77m8xl3a7yc5gqdsisz492dx2j8mck";
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
