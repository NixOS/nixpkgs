{ dfBaseVersion
, dfPatchVersion
, fetchzip
, ...
}:

let

  phoebusVersion = "00";
  phoebusFileName = "Phoebus_${dfBaseVersion}_${dfPatchVersion}v${phoebusVersion}";

in rec {

  src = fetchzip {
    name = phoebusFileName;
    url = "http://dffd.bay12games.com/download.php?id=2430&f=${phoebusFileName}.zip";
    sha256 = "0fb68r6fd7v67mbh2439ygqrmdk4pw94gd293fqxb9qg71ilrb6s";
    stripRoot = false;
  };

  sourceRoot = src.name;

  installPhase = ''
    pushd ../../$themeSourceRoot

    cp data/init/phoebus/* $out/share/df_linux/data/init/
    cp -rT raw $out/share/df_linux/raw
    mkdir -p $out/share/df_linux/data/config
    cp data/config/* $out/share/df_linux/data/config/
    cp data/art/* $out/share/df_linux/data/art/

    popd
  '';

}

