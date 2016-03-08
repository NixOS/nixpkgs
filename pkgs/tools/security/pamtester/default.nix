{ stdenv, fetchurl, pam }:

stdenv.mkDerivation rec {
  name = "pamtester-0.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/pamtester/${name}.tar.gz";
    sha256 = "1mdj1wj0adcnx354fs17928yn2xfr1hj5mfraq282dagi873sqw3";
  };

  buildInputs = [ pam ];

  meta = with stdenv.lib; {
    description = "Utility program to test the PAM facility";
    homepage = http://pamtester.sourceforge.net/;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
