{ lib
, stdenvNoCC
, fetchurl
, jre
, makeWrapper
, unzip
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dex2jar";
  version  = "2.1";

  src = fetchurl {
    url = "https://github.com/pxb1988/dex2jar/releases/download/v${finalAttrs.version}/dex2jar-${finalAttrs.version}.zip";
    hash = "sha256-epvfhD1D3k0elOwue29VglAXsMSn7jn/gmYOJJOkbwg=";
  };

  nativeBuildInputs = [ makeWrapper unzip ];

  postPatch = ''
    rm *.bat
    chmod +x *.sh
  '';

  installPhase = ''
    f=$out/share/dex2jar/

    mkdir -p $f $out/bin

    mv * $f
    for i in $f/*.sh; do
      n=$(basename ''${i%.sh})
      makeWrapper $i $out/bin/$n --prefix PATH : ${lib.makeBinPath [ jre ] }
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/pxb1988/dex2jar";
    description = "Tools to work with android .dex and java .class files";
    maintainers = with maintainers; [ makefu ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
})
