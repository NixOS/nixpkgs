{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "cb1cat-${version}";
  version = "20140403153000";

  src = fetchurl {
    url    = "https://www.cblnk.com/cb1cat/dist/${name}.tgz";
    sha256 = "1zi0rxbgmp6vkcarg493gfgn7pnfdpz0iplcgslbc45n2bxkv70q";
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
