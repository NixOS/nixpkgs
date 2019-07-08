{ stdenv, fetchurl, cmake, recode, perl }:

let srcs = {
      fortune = fetchurl {
        url = "https://github.com/shlomif/fortune-mod/archive/fortune-mod-${version}.tar.gz";
        sha256 = "89223bb649ea62b030527f181539182d6a17a1a43b0cc499a52732b839f7b691";
      };
      shlomifCommon = fetchurl {
        url = https://bitbucket.org/shlomif/shlomif-cmake-modules/raw/default/shlomif-cmake-modules/Shlomif_Common.cmake;
        sha256 = "62f188a9f1b7ab0e757eb0bc6540d9c0026d75edc7acc1c3cdf7438871d0a94f";
      };
    };
    version = "2.6.2";
in
stdenv.mkDerivation {
  name = "fortune-mod-${version}";

  src = srcs.fortune;

  sourceRoot = "fortune-mod-fortune-mod-${version}/fortune-mod";

  nativeBuildInputs = [ cmake perl ];

  buildInputs = [ recode ];

  preConfigure = ''
    cp ${srcs.shlomifCommon} cmake/Shlomif_Common.cmake
  '';

  postInstall = ''
    mv $out/games/fortune $out/bin/fortune
    rm -r $out/games
  '';

  meta = with stdenv.lib; {
    description = "A program that displays a pseudorandom message from a database of quotations";
    license = licenses.bsdOriginal;
    platforms = platforms.unix;
  };
}
