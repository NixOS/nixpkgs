{stdenv, fetchurl, cmake, libcap, zlib, bzip2}:

stdenv.mkDerivation rec {
  name = "cdrkit-1.1.9";

  src = fetchurl {
    url = "http://cdrkit.org/releases/${name}.tar.gz";
    sha256 = "18pgak1qh2xsb3sjikfh1hqn27v2ax72nx7r7sjkdw5yqys8mmfm";
  };

  buildInputs = [cmake libcap zlib bzip2];

  makeFlags = "PREFIX=\$(out)";

  meta = {
    description = "Portable command-line CD/DVD recorder software, mostly compatible with cdrtools";

    longDescription = ''
      Cdrkit is a suite of programs for recording CDs and DVDs,
      blanking CD-RW media, creating ISO-9660 filesystem images,
      extracting audio CD data, and more.  The programs included in
      the cdrkit package were originally derived from several sources,
      most notably mkisofs by Eric Youngdale and others, cdda2wav by
      Heiko Eissfeldt, and cdrecord by Jörg Schilling.  However,
      cdrkit is not affiliated with any of these authors; it is now an
      independent project.
    '';
    
    homepage = http://cdrkit.org/;
    license = "GPLv2";
  };
}
