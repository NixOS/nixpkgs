{ stdenv, execline, fetchgit, s6, s6-dns, skalibs

# Whether to build the TLS/SSL tools and what library to use
# acceptable values: "libressl", false
# TODO: add bearssl
, sslSupport ? "libressl" , libressl
}:

let
  inherit (stdenv) lib;

  version = "2.3.0.2";

  sslSupportEnabled = sslSupport != false;
  sslLibs = {
    "libressl" = libressl;
  };

in
assert sslSupportEnabled -> sslLibs ? ${sslSupport};

stdenv.mkDerivation rec {

  name = "s6-networking-${version}";

  src = fetchgit {
    url = "git://git.skarnet.org/s6-networking";
    rev = "refs/tags/v${version}";
    sha256 = "1qrhca8yjaysrqf7nx3yjfyfi9yly3rxpgrd2sqj0a0ckk73rv42";
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
    "--with-include=${s6-dns.dev}/include"
    "--with-lib=${skalibs.lib}/lib"
    "--with-lib=${execline.lib}/lib"
    "--with-lib=${s6.out}/lib"
    "--with-lib=${s6-dns.lib}/lib"
    "--with-dynlib=${skalibs.lib}/lib"
    "--with-dynlib=${execline.lib}/lib"
    "--with-dynlib=${s6.out}/lib"
    "--with-dynlib=${s6-dns.lib}/lib"
  ]
  ++ (lib.optionals sslSupportEnabled [
       "--enable-ssl=${sslSupport}"
       "--with-include=${lib.getDev sslLibs.${sslSupport}}/include"
       "--with-lib=${lib.getLib sslLibs.${sslSupport}}/lib"
     ])
  ++ (lib.optional stdenv.isDarwin "--build=${stdenv.hostPlatform.system}");

  postInstall = ''
    mkdir -p $doc/share/doc/s6-networking/
    mv doc $doc/share/doc/s6-networking/html
  '';

  meta = {
    homepage = http://www.skarnet.org/software/s6-networking/;
    description = "A suite of small networking utilities for Unix systems";
    platforms = lib.platforms.all;
    license = lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ pmahoney Profpatsch ];
  };

}
