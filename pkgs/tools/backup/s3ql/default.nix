{ stdenv, fetchurl, python3Packages, sqlite  }:

python3Packages.buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "s3ql";
  version = "2.13";

  src = fetchurl {
    url = "https://bitbucket.org/nikratio/${pname}/downloads/${name}.tar.bz2";
    sha256 = "0bxps1iq0rv7bg2b8mys6zyjp912knm6zmafhid1jhsv3xyby4my";
  };

  propagatedBuildInputs = with python3Packages;
    [ sqlite apsw pycrypto requests defusedxml dugong llfuse ];

  meta = with stdenv.lib; {
    description = "A full-featured file system for online data storage";
    homepage = "https://bitbucket.org/nikratio/s3ql";
    license = licenses.gpl3;
    maintainers = with maintainers; [ rushmorem ];
    platforms = platforms.unix;
  };
}
