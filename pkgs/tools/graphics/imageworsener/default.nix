{ lib, stdenv
, fetchurl
, zlib
, libpng
, libjpeg
, libwebp
}:

stdenv.mkDerivation rec {
  pname = "imageworsener";
  version = "1.3.4";

  src = fetchurl {
    url = "https://entropymine.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1dhjhlfrdng50dxxd306adzm54ir62pz99h4v0yi6rg56nxv5q5s";
  };

  postPatch = ''
    patchShebangs tests/runtest
  '';

  postInstall = ''
    mkdir -p $out/share/doc/imageworsener
    cp readme.txt technical.txt $out/share/doc/imageworsener
  '';

  buildInputs = [ zlib libpng libjpeg libwebp ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A raster image scaling and processing utility";
    homepage = "https://entropymine.com/imageworsener/";
    changelog = "https://github.com/jsummers/${pname}/blob/${version}/changelog.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ emily smitop ];
    mainProgram = "imagew";
    platforms = platforms.all;
  };
}
