args: with args;
rec {
  name    = "texlive-extra-2014";
  version = "2014.20140528";

  src = fetchurl {
    url = "mirror://debian/pool/main/t/texlive-extra/texlive-extra_${version}.orig.tar.xz";
    sha256 = "1wlvafvc03qlic4gr883q3lvgjis0czw3z6gdp4qw8f51a0fyam9";
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
