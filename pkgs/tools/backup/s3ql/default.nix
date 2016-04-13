{ stdenv, fetchurl, python3Packages, sqlite  }:

python3Packages.buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "s3ql";
  version = "2.17.1";

  src = fetchurl {
    url = "https://bitbucket.org/nikratio/${pname}/downloads/${name}.tar.bz2";
    sha256 = "049vpvvkyia7v4v97rg2l01n43shrdxc1ik38bmjb2q4fvsh1pgx";
  };

  propagatedBuildInputs = with python3Packages;
    [ sqlite apsw pycrypto requests2 defusedxml dugong llfuse ];

  meta = with stdenv.lib; {
    description = "A full-featured file system for online data storage";
    homepage = "https://bitbucket.org/nikratio/s3ql";
    license = licenses.gpl3;
    maintainers = with maintainers; [ rushmorem ];
    platforms = platforms.linux;
  };
}
