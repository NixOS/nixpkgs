{ stdenv, fetchurl, skalibs }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "s6-portable-utils-${version}";
  version = "2.2.1.1";

  src = fetchurl {
    url = "https://www.skarnet.org/software/s6-portable-utils/${name}.tar.gz";
    sha256 = "0ca5iiq3n6isj64jb81xpwjzjx1q8jg145nnnn91ra2qqk93kqka";
  };

  outputs = [ "bin" "dev" "doc" "out" ];

  dontDisableStatic = true;

  configureFlags = [
    "--enable-absolute-paths"
    "--bindir=\${bin}/bin"
    "--includedir=\${dev}/include"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
    "--with-include=${skalibs.dev}/include"
    "--with-lib=${skalibs.lib}/lib"
    "--with-dynlib=${skalibs.lib}/lib"
  ]
  # On darwin, the target triplet from -dumpmachine includes version number, but
  # skarnet.org software uses the triplet to test binary compatibility.
  # Explicitly setting target ensures code can be compiled against a skalibs
  # binary built on a different version of darwin.
  # http://www.skarnet.org/cgi-bin/archive.cgi?1:mss:623:heiodchokfjdkonfhdph
  ++ (stdenv.lib.optional stdenv.isDarwin "--build=${stdenv.hostPlatform.system}");

  postInstall = ''
    mkdir -p $doc/share/doc/s6-portable-utils/
    mv doc $doc/share/doc/s6-portable-utils/html
  '';

  meta = {
    homepage = http://www.skarnet.org/software/s6-portable-utils/;
    description = "A set of tiny general Unix utilities optimized for simplicity and small size";
    platforms = platforms.all;
    license = licenses.isc;
    maintainers = with maintainers; [ pmahoney Profpatsch ];
  };

}
