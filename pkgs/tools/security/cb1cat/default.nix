{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "cb1cat-${version}";
  version = "20140328100000";

  src = fetchurl {
    url    = "https://www.cblnk.com/cb1cat/dist/${name}.tgz";
    sha256 = "0fbly4fg2qsb4kx9wgv357bsa3mmmy8xmy0yszw80k50ixphjswv";
  };

  installPhase = ''
    mkdir -p $out/bin
    mv cb1cat $out/bin
  '';

  meta = {
    description = "cryptographic tool based on the CBEAMr1 sponge function";
    homepage    = "https://www.cblnk.com/cb1cat/";
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
