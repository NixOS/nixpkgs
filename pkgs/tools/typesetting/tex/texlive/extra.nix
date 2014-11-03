args: with args;
rec {
  name    = "texlive-extra-2014";
  version = "2014.20140927";

  src = fetchurl {
    url = "mirror://debian/pool/main/t/texlive-extra/texlive-extra_${version}.orig.tar.xz";
    sha256 = "0chbl20dh61ld7nq9aiay7hi371l6285c2caqz18br29ifh8jicd";
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
