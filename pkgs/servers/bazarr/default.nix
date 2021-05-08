{ stdenv, lib, fetchurl, makeWrapper, python3, unrar, ffmpeg, nixosTests }:

stdenv.mkDerivation rec {
  pname = "bazarr";
  version = "0.9.4";

  src = fetchurl {
    url = "https://github.com/morpheus65535/bazarr/archive/v${version}.tar.gz";
    sha256 = "1qnzjqpwsvanfhd1yn5789yx4d3ijk9983llm0w5xnjz6rmcxrw5";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/src
    cp -r * $out/src

    mkdir -p $out/bin
    makeWrapper "${(python3.withPackages (ps: [ps.lxml ps.numpy])).interpreter}" \
      $out/bin/bazarr \
      --add-flags "$out/src/bazarr.py" \
      --suffix PATH : ${lib.makeBinPath [ unrar ffmpeg ]} \
  '';

  passthru.tests = {
    smoke-test = nixosTests.bazarr;
  };

  meta = with lib; {
    description = "Subtitle manager for Sonarr and Radarr";
    homepage = "https://www.bazarr.media/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ xwvvvvwx ];
    platforms = platforms.all;
  };
}
