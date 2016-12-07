{ stdenv, fetchOneOf }:

let
  version = "2.9";
  fileVersion = builtins.replaceStrings [ "." ] [ "_" ] version;
  baseURL = "http://kindlegen.s3.amazonaws.com";
  src = fetchOneOf stdenv.system {
    "x86_64-linux"  = {
      url = "${baseURL}/kindlegen_linux_2.6_i386_v${fileVersion}.tar.gz";
      sha256 = "15i20kzhdcmi94w7wfhqbl6j20v47cdakjm2mn3x8w495iddna4q";
    };
    "i686-linux"    = {
      url = "${baseURL}/kindlegen_linux_2.6_i386_v${fileVersion}.tar.gz";
      sha256 = "15i20kzhdcmi94w7wfhqbl6j20v47cdakjm2mn3x8w495iddna4q";
    };
    "x86_64-darwin" = {
      url = "${baseURL}/KindleGen_Mac_i386_v${fileVersion}.zip";
      sha256 = "0zniyn0s41fxqrajbgwxbcsj5vzf9m7a6yvdz2b11mphr00kpbbs";
    };
    "i686-darwin"   = {
      url = "${baseURL}/KindleGen_Mac_i386_v${fileVersion}.zip";
      sha256 = "0zniyn0s41fxqrajbgwxbcsj5vzf9m7a6yvdz2b11mphr00kpbbs";
    };
    "x86_64-cygwin" = {
      url = "${baseURL}/kindlegen_win32_v${fileVersion}.zip";
      sha256 = "02slfh1bbpijay4skj85cjiv7z43ha8vm5aa1lwiqjk86qbl1f3h";
    };
    "i686-cygwin"   = {
      url = "${baseURL}/kindlegen_win32_v${fileVersion}.zip";
      sha256 = "02slfh1bbpijay4skj85cjiv7z43ha8vm5aa1lwiqjk86qbl1f3h";
    };
  };

in stdenv.mkDerivation rec {
  name = "kindlegen-${version}";

  inherit src;

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin $out/share/kindlegen/doc
    install -m755 kindlegen $out/bin/kindlegen
    cp -r *.txt *.html docs/* $out/share/kindlegen/doc
  '';

  meta = with stdenv.lib; {
    description = "Convert documents to .mobi for use with Amazon Kindle";
    homepage = https://www.amazon.com/gp/feature.html?docId=1000765211;
    license = licenses.unfree;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "i686-darwin" "x86_64-cygwin" "i686-cygwin" ];
  };
}
