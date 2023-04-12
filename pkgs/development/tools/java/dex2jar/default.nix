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
  version  = "2.0";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.zip";
    sha256 = "1g3mrbyl8sdw1nhp17z23qbfzqpa0w2yxrywgphvd04jdr6yn1vr";
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
