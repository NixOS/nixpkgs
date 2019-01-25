{ stdenv, fetchFromGitHub, pkgconfig, cmake, makeWrapper }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "20180320";
  name = "zxing-cpp-${version}";

  src = fetchFromGitHub {
    owner = "glassechidna";
    repo = "zxing-cpp";
    rev = "5aad4744a3763d814df98a18886979893e638274";
    sha256 = "07xshbh656a26bi8bii6ffw3fahnfj6755f6ybmmmplk55xxnlg8";
  };

  nativeBuildInputs = [ pkgconfig cmake makeWrapper ];
  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/glassechidna/zxing-cpp;
    description = "Unofficial C++ Port of Java ZXing library";
    license = licenses.asl20;
    maintainers = with maintainers; [ voobscout ];
  };
}
