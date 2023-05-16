<<<<<<< HEAD
{ lib
, stdenvNoCC
=======
{ stdenv
, lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchurl
, jre
, makeWrapper
, unzip
}:
<<<<<<< HEAD

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dex2jar";
  version  = "2.1";

  src = fetchurl {
    url = "https://github.com/pxb1988/dex2jar/releases/download/v${finalAttrs.version}/dex2jar-${finalAttrs.version}.zip";
    hash = "sha256-epvfhD1D3k0elOwue29VglAXsMSn7jn/gmYOJJOkbwg=";
=======
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dex2jar";
  version  = "2.0";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.zip";
    sha256 = "1g3mrbyl8sdw1nhp17z23qbfzqpa0w2yxrywgphvd04jdr6yn1vr";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ makeWrapper unzip ];

  postPatch = ''
    rm *.bat
    chmod +x *.sh
  '';

  installPhase = ''
<<<<<<< HEAD
    f=$out/share/dex2jar/
=======
    f=$out/lib/dex2jar/
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    mkdir -p $f $out/bin

    mv * $f
    for i in $f/*.sh; do
      n=$(basename ''${i%.sh})
      makeWrapper $i $out/bin/$n --prefix PATH : ${lib.makeBinPath [ jre ] }
    done
  '';

  meta = with lib; {
<<<<<<< HEAD
    homepage = "https://github.com/pxb1988/dex2jar";
    description = "Tools to work with android .dex and java .class files";
    maintainers = with maintainers; [ makefu ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
})
=======
    homepage = "https://sourceforge.net/projects/dex2jar/";
    description = "Tools to work with android .dex and java .class files";
    maintainers = with maintainers; [ makefu ];
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
