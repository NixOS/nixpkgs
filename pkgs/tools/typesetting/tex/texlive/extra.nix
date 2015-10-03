args @ { texLive, xz, ... }: with args;
rec {
  name    = "texlive-extra-2014";
  version = "2014.20141024";

  src = fetchurl {
    url = "mirror://debian/pool/main/t/texlive-extra/texlive-extra_${version}.orig.tar.xz";
    sha256 = "190p5v6madcgkxjmfal0pcylfz88zi6yaixky0vrcz1kbvxqlcb9";
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
    maintainers = [ args.lib.maintainers.raskin args.lib.maintainers.jwiegley ];

    # Actually, arch-independent..
    hydraPlatforms = [];
  };
}
