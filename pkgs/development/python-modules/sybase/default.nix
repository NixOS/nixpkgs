{ lib
, buildPythonPackage
, fetchurl
, isPy3k
, freetds
}:

buildPythonPackage rec {
  pname = "python-sybase";
  version = "0.40pre2";
  disabled = isPy3k;

  src = fetchurl {
    url = "https://sourceforge.net/projects/python-sybase/files/python-sybase/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "0pm88hyn18dy7ljam4mdx9qqgmgraf2zy2wl02g5vsjl4ncvq90j";
  };

  propagatedBuildInputs = [ freetds ];

  SYBASE = freetds;
  setupPyBuildFlags = [ "-DHAVE_FREETDS" "-UWANT_BULKCOPY" ];

  meta = with lib; {
    description = "The Sybase module provides a Python interface to the Sybase relational database system";
    homepage    = "http://python-sybase.sourceforge.net";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
    platforms   = platforms.unix;
  };
}
