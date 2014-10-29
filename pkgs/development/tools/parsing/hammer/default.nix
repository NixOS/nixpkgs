{ stdenv, fetchgit, glib, pkgconfig, python, scons, pythonPackages }:

stdenv.mkDerivation rec {

name = "hammer-${version}";
version = "1.0.0-rc3";

src = fetchgit {
    url = "git://github.com/UpstandingHackers/hammer";
    sha256 = "1ay790qi127crxncgsdi4qvai1s0ckq0yzzk19b1zvdlws4rvw93";
};

buildInputs = [ glib pkgconfig python scons ];

buildPhase = "scons prefix=$out";

installPhase = "scons prefix=$out install";

meta = with stdenv.lib; {
     description = "Hammer is a parsing library. Like many modern parsing libraries,
	       it provides a parser combinator interface for writing grammars
	       as inline domain-specific languages, but Hammer also provides a
	       variety of parsing backends. It's also bit-oriented rather than
	       character-oriented, making it ideal for parsing binary data such
	       as images, network packets, audio, and executables.";
     homepage = https://github.com/UpstandingHackers/hammer;
     license = licenses.gpl2;
     platforms = platforms.linux;
     };
}