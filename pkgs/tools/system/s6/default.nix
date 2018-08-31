{ stdenv, execline, fetchgit, skalibs }:

let

  version = "2.7.1.1";

in stdenv.mkDerivation rec {

  name = "s6-${version}";

  src = fetchgit {
    url = "git://git.skarnet.org/s6";
    rev = "refs/tags/v${version}";
    sha256 = "0dncw3h9wc4cgc9q8zjwicgbcqcn6722yhk8g9bvrhs7h4fkfqav";
  };

  # NOTE lib: cannot split lib from bin at the moment,
  # since some parts of lib depend on executables in bin.
  # (the `*_startf` functions in `libs6`)

  outputs = [ /*"bin" "lib"*/ "out" "dev" "doc" ];

  dontDisableStatic = true;

  enableParallelBuilding = true;

  configureFlags = [
    "--enable-absolute-paths"
    "--libdir=\${out}/lib"
    "--libexecdir=\${out}/libexec"
    "--dynlibdir=\${out}/lib"
    "--bindir=\${out}/bin"
    "--includedir=\${dev}/include"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
    "--with-include=${skalibs.dev}/include"
    "--with-include=${execline.dev}/include"
    "--with-lib=${skalibs.lib}/lib"
    "--with-lib=${execline.lib}/lib"
    "--with-dynlib=${skalibs.lib}/lib"
    "--with-dynlib=${execline.lib}/lib"
  ]
  ++ (if stdenv.isDarwin then [ "--disable-shared" ] else [ "--enable-shared" ])
  ++ (stdenv.lib.optional stdenv.isDarwin "--build=${stdenv.hostPlatform.system}");

  postInstall = ''
    mkdir -p $doc/share/doc/s6/
    mv doc $doc/share/doc/s6/html
    mv examples $doc/share/doc/s6/examples
  '';

  meta = {
    homepage = http://www.skarnet.org/software/s6/;
    description = "skarnet.org's small & secure supervision software suite";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ pmahoney Profpatsch ];
  };

}
