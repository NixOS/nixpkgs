{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hyx-0.1.4";

  src = fetchurl {
    url = "https://yx7.cc/code/hyx/${name}.tar.xz";
    sha256 = "049r610hyrrfa62vpiqyb3rh99bpy8cnqy4nd4sih01733cmdhyx";
  };

  installPhase = ''
    install -vD hyx $out/bin/hyx
  '';

  meta = with lib; {
    description = "minimalistic but powerful Linux console hex editor";
    homepage = https://yx7.cc/code/;
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.all;
  };
}
