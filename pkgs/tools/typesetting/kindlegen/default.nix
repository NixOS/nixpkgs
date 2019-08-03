{ fetchurl, stdenv, unzip }:

let
  version = "2.9";
  fileVersion = builtins.replaceStrings [ "." ] [ "_" ] version;

  sha256 = {
    "x86_64-linux"  = "15i20kzhdcmi94w7wfhqbl6j20v47cdakjm2mn3x8w495iddna4q";
    "i686-linux"    = "15i20kzhdcmi94w7wfhqbl6j20v47cdakjm2mn3x8w495iddna4q";
    "x86_64-darwin" = "0zniyn0s41fxqrajbgwxbcsj5vzf9m7a6yvdz2b11mphr00kpbbs";
    "i686-darwin"   = "0zniyn0s41fxqrajbgwxbcsj5vzf9m7a6yvdz2b11mphr00kpbbs";
    "x86_64-cygwin" = "02slfh1bbpijay4skj85cjiv7z43ha8vm5aa1lwiqjk86qbl1f3h";
    "i686-cygwin"   = "02slfh1bbpijay4skj85cjiv7z43ha8vm5aa1lwiqjk86qbl1f3h";
  }."${stdenv.hostPlatform.system}" or (throw "system #{stdenv.hostPlatform.system.} is not supported");

  url = {
    "x86_64-linux"  = "http://kindlegen.s3.amazonaws.com/kindlegen_linux_2.6_i386_v${fileVersion}.tar.gz";
    "i686-linux"    = "http://kindlegen.s3.amazonaws.com/kindlegen_linux_2.6_i386_v${fileVersion}.tar.gz";
    "x86_64-darwin" = "http://kindlegen.s3.amazonaws.com/KindleGen_Mac_i386_v${fileVersion}.zip";
    "i686-darwin"   = "http://kindlegen.s3.amazonaws.com/KindleGen_Mac_i386_v${fileVersion}.zip";
    "x86_64-cygwin" = "http://kindlegen.s3.amazonaws.com/kindlegen_win32_v${fileVersion}.zip";
    "i686-cygwin"   = "http://kindlegen.s3.amazonaws.com/kindlegen_win32_v${fileVersion}.zip";
  }."${stdenv.hostPlatform.system}" or (throw "system #{stdenv.hostPlatform.system.} is not supported");

in stdenv.mkDerivation rec {
  name = "kindlegen-${version}";

  src = fetchurl {
    inherit url;
    inherit sha256;
  };

  sourceRoot = ".";

  nativeBuildInputs = stdenv.lib.optional (stdenv.lib.hasSuffix ".zip" url) unzip;

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
