{ stdenv
, fetchurl
, zlib
, libpng
, libjpeg
, libwebp
}:

stdenv.mkDerivation rec {
  pname = "imageworsener";
  version = "1.3.3";

  src = fetchurl {
    url = "https://entropymine.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "099ymaqk7gj0plmdx7fxabbdx2n03d25r00ly0vf6cx37mgnwjvw";
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

  meta = with stdenv.lib; {
    description = "A raster image scaling and processing utility";
    homepage = https://entropymine.com/imageworsener/;
    changelog = "https://github.com/jsummers/${pname}/blob/${version}/changelog.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ emily ];
    platforms = platforms.all;
  };
}
