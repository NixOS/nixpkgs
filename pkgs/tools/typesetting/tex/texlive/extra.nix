args: with args;
rec {
  name    = "texlive-extra-2014";
  version = "2014.20140821";

  src = fetchurl {
    url = "mirror://debian/pool/main/t/texlive-extra/texlive-extra_${version}.orig.tar.xz";
    sha256 = "1y3w8bgp85s90ng2y5dw9chrrvvdf7ibb6ynss8kycvgc0y4m6b3";
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
