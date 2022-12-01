{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "rcm";
  version = "1.3.5";

  src = fetchurl {
    url = "https://thoughtbot.github.io/rcm/dist/rcm-${version}.tar.gz";
    sha256 = "sha256-JHQefybxagSTJLqoavcARDxCgeLN4JlynXTE1LKevi0=";
  };

  patches = [ ./fix-rcmlib-path.patch ];

  postPatch = ''
    for f in bin/*.in; do
      substituteInPlace $f --subst-var-by rcm $out
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/thoughtbot/rcm";
    description = "Management Suite for Dotfiles";
    license = licenses.bsd3;
    maintainers = with maintainers; [ malyn AndersonTorres ];
    platforms = with platforms; unix;
  };
}
