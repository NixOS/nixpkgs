args: with args;
rec {
  name    = "texlive-extra-2013";
  version = "2013.20140408";

  src = fetchurl {
    url = "mirror://debian/pool/main/t/texlive-extra/texlive-extra_${version}.orig.tar.xz";
    sha256 = "0d6b5kip7j8ljqn92bkdncvqxyk2756404hzsp4mh0s1jhfwws7y";
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
