args: with args;
rec {
  name    = "texlive-extra-2013";
  version = "2013.20140314";

  src = fetchurl {
    url = "mirror://debian/pool/main/t/texlive-extra/texlive-extra_${version}.orig.tar.xz";
    sha256 = "6b4216fe87c354a0c3c8ec456272cc096a7ec112a68031797ae23f18e1e5b74c";
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
