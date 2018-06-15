{ stdenv, fetchurl, cmake, pkgconfig
, qtbase, gsl, getdata, netcdf, muparser, matio
}:
stdenv.mkDerivation rec {
  name = "Kst-2.0.8";
  src = fetchurl {
    url = "mirror://sourceforge/kst/${name}.tar.gz";
    sha256 = "1ihqmwqw0h2p7hn5shd8iwb0gd4axybs60lgw22ijxqh6wzgvyyf";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ qtbase gsl getdata netcdf muparser matio ];

  cmakeFlags = "-Dkst_qt5=1 -Dkst_release=1";

  postInstall = ''
    mkdir -p $out
    for d in bin lib share
    do
      cp -r INSTALLED/$d $out/
    done
  '';

  meta = with stdenv.lib; {
    description = "Real-time large-dataset viewing and plotting tool";
    homepage = https://kst-plot.kde.org/;
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    broken = true;
  };
}
