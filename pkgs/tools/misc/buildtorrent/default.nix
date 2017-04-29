{ stdenv, fetchurl }:

let version = "0.8"; in

stdenv.mkDerivation rec {
	name = "buildtorrent";

	src = fetchurl {
		url = "http://mathr.co.uk/blog/code/${name}-${version}.tar.gz";
		sha256 = "e8e27647bdb38873ac570d46c1a9689a92b01bb67f59089d1cdd08784f7052d0";
	};

	meta = {
		description = "A simple commandline torrent creator";
		homepage = http://mathr.co.uk/blog/torrent.html;
		license = stdenv.lib.licenses.gpl3Plus;
		platforms = stdenv.lib.platforms.all;
	};
}