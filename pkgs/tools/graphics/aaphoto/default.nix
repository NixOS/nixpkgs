{ lib
, stdenv
, fetchurl
, jasper
, libpng
, libjpeg
, zlib
, llvmPackages
}:

stdenv.mkDerivation rec {
  pname = "aaphoto";
  version = "0.45";

  src = fetchurl {
    url = "http://log69.com/downloads/aaphoto_sources_${version}.tar.gz";
    sha256 = "sha256-06koJM7jNVFqVgqg6BmOZ74foqk6yjUIFnwULzPZ4go=";
  };

  nativeBuildInputs = lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  buildInputs = [
    jasper
    libpng
    libjpeg
    zlib
  ];

  postInstall = ''
    install -Dm644 NEWS README REMARKS TODO -t $out/share/doc/${pname}
  '';

  meta = with lib; {
    homepage = "http://log69.com/aaphoto_en.html";
    description = "Free and open source automatic photo adjusting software";
    longDescription = ''
      Auto Adjust Photo tries to give a solution for the automatic color
      correction of photos. This means setting the contrast, color balance,
      saturation and gamma levels of the image by analization.

      This can be a solution for those kind of users who are not able to manage
      and correct images with complicated graphical softwares, or just simply
      don't intend to spend a lot of time with manually correcting the images
      one-by-one.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
    mainProgram = "aaphoto";
  };
}
