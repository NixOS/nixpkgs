{ stdenv, fetchurl, cmake, recode, perl }:

let srcs = {
      fortune = fetchurl {
        url = https://github.com/shlomif/fortune-mod/archive/fortune-mod-2.6.2.tar.gz;
        sha256 = "89223bb649ea62b030527f181539182d6a17a1a43b0cc499a52732b839f7b691";
      };
      shlomifCommon = fetchurl {
        url = https://bitbucket.org/shlomif/shlomif-cmake-modules/raw/default/shlomif-cmake-modules/Shlomif_Common.cmake;
        sha256 = "62f188a9f1b7ab0e757eb0bc6540d9c0026d75edc7acc1c3cdf7438871d0a94f";
      };
    };
in
stdenv.mkDerivation {
  name = "fortune-mod-2.6.2";

  src = srcs.fortune;

  sourceRoot = "fortune-mod-fortune-mod-2.6.2/fortune-mod";

  buildInputs = [ cmake recode perl ];

  preConfigure = ''
    cp ${srcs.shlomifCommon} cmake/Shlomif_Common.cmake
  '';

  configureScript = ''
    cmake -DCMAKE_INSTALL_PREFIX=$out .
  '';

  preBuild = ''
    makeFlagsArray=("CC=$CC" "REGEXDEFS=-DHAVE_REGEX_H -DPOSIX_REGEX" "LDFLAGS=")
  '';

  postInstall = ''
    cp $out/games/fortune $out/bin/fortune
  '';

  meta = with stdenv.lib; {
    description = "A program that displays a pseudorandom message from a database of quotations";
    license = licenses.bsdOriginal;
    platforms = platforms.unix;
  };
}
