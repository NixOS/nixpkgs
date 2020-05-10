{ stdenv, lib, fetchurl, makeWrapper, python3, nixosTests }:

stdenv.mkDerivation rec {
  pname = "bazarr";
  version = "0.8.4.3";

  src = fetchurl {
    url = "https://github.com/morpheus65535/bazarr/archive/v${version}.tar.gz";
    sha256 = "0vvx1lrngxq8c9i0ad8sy6sigcf67b2h7kkaxnlfdlnp1d8kmf1m";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/src
    cp -r * $out/src

    mkdir -p $out/bin
    makeWrapper "${(python3.withPackages (ps: [ps.lxml])).interpreter}" \
      $out/bin/bazarr \
      --add-flags "$out/src/bazarr.py" \
  '';

  passthru.tests = {
    smoke-test = nixosTests.bazarr;
  };

  meta = with lib; {
    description = "Subtitle manager for Sonarr and Radarr";
    homepage = "https://www.bazarr.media/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ xwvvvvwx ];
    platforms = platforms.all;
  };
}
