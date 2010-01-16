{stdenv, fetchurl, cmake, libcap, zlib, bzip2}:

stdenv.mkDerivation rec {
  name = "cdrkit-1.1.10";

  src = fetchurl {
    url = "http://cdrkit.org/releases/${name}.tar.gz";
    sha256 = "1r87n4293lk2xgik9x1lvjr86rdsbaldf0d5flx6zb4c0ss90vlb";
  };

  buildInputs = [cmake libcap zlib bzip2];

  patches = [ ./include-path.patch ];

  postInstall = ''
    # file name compatibility with the old cdrecord (growisofs wants this name)
    ln -s $out/bin/genisoimage $out/bin/mkisofs
    ln -s $out/bin/wodim $out/bin/cdrecord
  '';

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
