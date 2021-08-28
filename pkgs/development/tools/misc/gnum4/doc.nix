{ stdenv, gnum4, texinfo4 }:
stdenv.mkDerivation {
  inherit (gnum4) src version;
  pname = "gnum4-doc";
  outputs = [ "out" "html" "txt" ];
  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  nativeBuildInputs = [ texinfo4 ];

  buildPhase = ''
    makeinfo --html --no-split doc/m4.texi
    makeinfo --plaintext --no-split doc/m4.texi > m4.txt
  '';
  installPhase = ''
    mkdir $out
    mkdir -p {$txt,$html}/share/doc/m4
    cp ./m4.html $html/share/doc/m4
    cp ./m4.txt $txt/share/doc/m4
  '';
}
