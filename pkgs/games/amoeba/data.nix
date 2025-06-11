{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "amoeba-data";
  version = "1.1";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/non-free/a/amoeba-data/amoeba-data_${version}.orig.tar.gz";
    sha256 = "1bgclr1v63n14bj9nwzm5zxg48nm0cla9bq1rbd5ylxra18k0jbg";
  };

  installPhase = ''
    mkdir -p $out/share/amoeba
    cp demo.dat $out/share/amoeba/
  '';

  meta = with lib; {
    description = "Fast-paced, polished OpenGL demonstration by Excess (data files)";
    homepage = "https://packages.qa.debian.org/a/amoeba-data.html";
    license = licenses.unfree;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.all;
  };
}
