{ lib, stdenv, fetchFromGitHub, jasper, libpng, libjpeg, zlib }:

stdenv.mkDerivation rec {
  pname = "aaphoto";
  version = "0.43.1";

  src = fetchFromGitHub {
    owner = "log69";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qngWWqV2vLm1gO0KJ0uHOCf2IoEAs1oiygpJtDvt3s8=";
  };

  buildInputs = [ jasper libpng libjpeg zlib ];

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
    broken =
      stdenv.isDarwin; # aaphoto.c:237:10: fatal error: 'omp.h' file not found
  };
}
