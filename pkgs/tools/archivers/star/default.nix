{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "star-${version}";
  version = "1.5.3";
  src = fetchurl {
    url = "https://sourceforge.net/projects/s-tar/files/${name}.tar.gz";
    sha256 = "1yii6p6x38r6w12s5yrdi08aij481jcg3xf8g738nmh0hqypbfl7";
  };

  preConfigure = "rm configure";
  preBuild = "sed 's_/bin/__g' -i RULES/*";
  makeFlags = [ "DESTDIR=$(out)" "INS_BASE=/ install"];
  postInstall = ''
  find $out/bin -type l -delete
  rm -r $out/etc $out/include $out/sbin
  '';

  meta = {
    description = "Star is a very fast tar like tape archiver with  improved functionality.";
    longDescription = ''
Star archives and extracts multiple files to and from a single file called a tarfile.
A tarfile is usually a magnetic tape, but it can be any file.
In all cases, appearance of a directory name refers to the files and (recursively) sub-directories of that directory.
Star's actions are controlled by the mandatory command flags from the list below.
The way star acts may be modified by additional options.
Note that unpacking tar archives may be a security risk because star may overwrite existing files.
    '';
    homepage = http://cdrtools.sourceforge.net/private/star.html;
    license = stdenv.lib.licenses.cddl;
    maintainers = [ stdenv.lib.maintainers.wucke13 ];
    platforms = stdenv.lib.platforms.all;
  };
}
