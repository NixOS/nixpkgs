args: with args;
rec {
  name    = "texlive-extra-2013";
  version = "2013.20140215";

  src = fetchurl {
    url = "mirror://debian/pool/main/t/texlive-extra/texlive-extra_${version}.orig.tar.xz";
    sha256 = "04a67pns6q8kw1nl2v6x5p443kvhk8fr26qkcj7z098n68fpwls8";
  };

  buildInputs = [texLive xz];
  phaseNames = ["doCopy"];
  doCopy = fullDepEntry (''
    mkdir -p $out/share
    cp -r texmf* $out/
    ln -s $out/texmf* $out/share
  '') ["minInit" "doUnpack" "defEnsureDir" "addInputs"];

  meta = {
    description = "Extra components for TeXLive";
    maintainers = [ args.lib.maintainers.raskin ];

    # Actually, arch-independent.. 
    hydraPlatforms = [];
  };
}
