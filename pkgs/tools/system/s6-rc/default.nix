{ stdenv, execline, fetchgit, skalibs, s6 }:

let

  version = "0.4.0.1";

in stdenv.mkDerivation rec {

  name = "s6-rc-${version}";

  src = fetchgit {
    url = "git://git.skarnet.org/s6-rc";
    rev = "refs/tags/v${version}";
    sha256 = "10gkkdbvkb4s2yshx425v9diwm7vvbl320a2bm0c3wz71xr94wsw";
  };

  outputs = [ "bin" "lib" "dev" "doc" "out" ];

  dontDisableStatic = true;

  enableParallelBuilding = true;

  configureFlags = [
    "--enable-absolute-paths"
    "--libdir=\${lib}/lib"
    "--libexecdir=\${lib}/libexec"
    "--dynlibdir=\${lib}/lib"
    "--bindir=\${bin}/bin"
    "--includedir=\${dev}/include"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
    "--with-include=${skalibs.dev}/include"
    "--with-include=${execline.dev}/include"
    "--with-include=${s6.dev}/include"
    "--with-lib=${skalibs.lib}/lib"
    "--with-lib=${execline.lib}/lib"
    "--with-lib=${s6.out}/lib"
    "--with-dynlib=${skalibs.lib}/lib"
    "--with-dynlib=${execline.lib}/lib"
    "--with-dynlib=${s6.out}/lib"
  ]
  ++ (if stdenv.isDarwin then [ "--disable-shared" ] else [ "--enable-shared" ])
  ++ (stdenv.lib.optional stdenv.isDarwin "--build=${stdenv.hostPlatform.system}");

  postInstall = ''
    mkdir -p $doc/share/doc/s6-rc/
    mv doc $doc/share/doc/s6-rc/html
    mv examples $doc/share/doc/s6-rc/examples
  '';

  meta = {
    homepage = http://skarnet.org/software/s6-rc/;
    description = "A service manager for s6-based systems";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ pmahoney Profpatsch ];
  };

}
