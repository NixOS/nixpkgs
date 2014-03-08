{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "cb0cat-${version}";
  version = "20131216153906";

  src = fetchurl {
    url    = "https://www.cblnk.com/cb0cat/dist/${name}.tgz";
    sha256 = "182767nxfyiis7ac8bn5v8rxb9vlly8n5w42pz1dd0751xwdlp82";
  };

  installPhase = ''
    mkdir -p $out/bin
    mv cb0cat $out/bin
  '';

  meta = {
    description = "cryptographic tool based on the CBEAMr0 sponge function";
    homepage    = "https://www.cblnk.com";
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
