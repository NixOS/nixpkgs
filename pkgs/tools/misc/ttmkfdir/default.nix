args: with args; with debPackage;
debBuild ({
  src = 
	fetchurl {
		url = http://ftp.de.debian.org/debian/pool/main/t/ttmkfdir/ttmkfdir_3.0.9.orig.tar.gz;
		sha256 = "0n6bmmndmp4c1myisvv7cby559gzgvwsw4rfw065a3f92m87jxiq";
	};
  patch = fetchurl {
		url = http://ftp.de.debian.org/debian/pool/main/t/ttmkfdir/ttmkfdir_3.0.9-5.1.diff.gz;
		sha256 = "1500kwvhxfq85zg7nwnn9dlvjxyg2ni7as17gdfm67pl9a45q3w4";
	};
  patches = [ ./cstring.patch ];
  name = "ttf-mkfontdir-3.0.9-5.1";
  buildInputs = [fontconfig freetype libunwind libtool 
  	flex bison];
  meta = {
    description = "Create fonts.dir for TTF font directory.";
  };
  extraReplacements = ''sed -e 's/int isatty(int [^)]*)/& throw()/' '';
  omitConfigure = true;
} // args)

