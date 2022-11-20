{ stdenv
, lib
, fetchurl
, jre
, makeWrapper
, unzip
}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dex2jar";
  version  = "2.1";

  src = fetchurl {
    url = "https://github.com/pxb1988/${pname}/releases/download/v${version}/${name}.zip";
    sha256 = "sha256-epvfhD1D3k0elOwue29VglAXsMSn7jn/gmYOJJOkbwg=";
  };

  nativeBuildInputs = [ makeWrapper unzip ];

  postPatch = ''
    rm *.bat
    chmod +x *.sh
  '';

  installPhase = ''
    f=$out/lib/dex2jar/

    mkdir -p $f $out/bin

    mv * $f
    for i in $f/*.sh; do
      n=$(basename ''${i%.sh})
      makeWrapper $i $out/bin/$n --prefix PATH : ${lib.makeBinPath [ jre ] }
    done
  '';

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/dex2jar/";
    description = "Tools to work with android .dex and java .class files";
    maintainers = with maintainers; [ makefu ];
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
