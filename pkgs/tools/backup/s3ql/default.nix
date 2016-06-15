{ stdenv, fetchurl, python27Packages, sqlite  }:

python27Packages.buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "s3ql";
  version = "1.18.1";

  src = fetchurl {
    url = "https://bitbucket.org/nikratio/${pname}/downloads/${name}.tar.bz2";
    sha256 = "19bp3cz7by8025dar5d4lnqxyimsn0v10myqykhl4c818g9bi778";
  };

  propagatedBuildInputs = with python27Packages;
    [ sqlite apsw pycrypto pycryptopp requests2 defusedxml dugong llfuse ];

  meta = with stdenv.lib; {
    description = "A full-featured file system for online data storage";
    homepage = "https://bitbucket.org/nikratio/s3ql";
    license = licenses.gpl3;
    maintainers = [ maintainers.rushmorem ];
    platforms = platforms.linux;
  };
}
