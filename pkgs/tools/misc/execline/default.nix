{ stdenv, fetchgit, skalibs }:

let

  version = "2.3.0.3";

in stdenv.mkDerivation rec {

  name = "execline-${version}";

  src = fetchgit {
    url = "git://git.skarnet.org/execline";
    rev = "refs/tags/v${version}";
    sha256 = "1q0izb8ajzxl36fjpy4rn63sz01055r9s33fga99jprdmkkfzz6x";
  };

  outputs = [ "bin" "out" "dev" "doc" ];

  dontDisableStatic = true;

  enableParallelBuilding = true;

  configureFlags = [
    "--enable-absolute-paths"
    "--libdir=\${prefix}/lib"
    "--includedir=\${prefix}/include"
    "--with-sysdeps=${skalibs}/lib/skalibs/sysdeps"
    "--with-include=${skalibs}/include"
    "--with-lib=${skalibs}/lib"
    "--with-dynlib=${skalibs}/lib"
  ]
  ++ (if stdenv.isDarwin then [ "--disable-shared" ] else [ "--enable-shared" ])
  ++ (stdenv.lib.optional stdenv.isDarwin "--build=${stdenv.system}");

  postInstall = ''
    mkdir -p $doc/share/html/execline
    mv doc/* $doc/share/html/execline
  '';

  meta = {
    homepage = http://skarnet.org/software/execline/;
    description = "A small scripting language, to be used in place of a shell in non-interactive scripts";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ pmahoney ];
  };

}
