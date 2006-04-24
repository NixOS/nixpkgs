{stdenv, fetchurl, python, clearsilver, subversion, sqlite, pysqlite, makeWrapper}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
	name = "trac-0.9.5";
	src = fetchurl {
		url = "http://ftp.edgewall.com/pub/trac/trac-0.9.5.tar.gz";
		md5 = "3b7d708eaf905cc6ba2b6b10a09a8cf4";
	};
	builder = ./builder.sh;
	inherit stdenv python subversion clearsilver sqlite pysqlite makeWrapper;
}


