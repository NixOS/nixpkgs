{ stdenv, lib, fetchurl, makeWrapper, python3, unrar, ffmpeg, nixosTests }:

stdenv.mkDerivation rec {
  pname = "bazarr";
  version = "0.9.2";

  src = fetchurl {
    url = "https://github.com/morpheus65535/bazarr/archive/v${version}.tar.gz";
    sha256 = "16mh7v8z5ijr75pvavcj6225w6bg12qy1d1w9vm2d5axnfm3wfbk";
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
