{stdenv, lib, fetchurl, makeWrapper, unzip, jre}:

stdenv.mkDerivation rec {
  name = "ExcelCompare-${version}";
  version = "0.6.1";
  src = fetchurl {
    url = "https://github.com/na-ka-na/ExcelCompare/releases/download/${version}/ExcelCompare-${version}.zip";
    sha256 = "1304qraazqm8mgjgnijzl070l0haa8jds7spnsy3xwh3vda0ka4x";
  };
  buildInputs = [ jre ];
  nativeBuildInputs = [ unzip makeWrapper ];
  sourceRoot = ".";

  installPhase = ''
    install -Dt $out/share/excel_cmp bin/dist/*
    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/excel_cmp \
      --add-flags "-ea -cp $out/share/excel_cmp/\* com.ka.spreadsheet.diff.SpreadSheetDiffer"
  '';

  meta = {
    description = "Command line tool (and API) for diffing Excel Workbooks";
    homepage = https://github.com/na-ka-na/ExcelCompare;
    maintainers = stdenv.lib.maintainers.ilikeavocadoes;
  };
}
