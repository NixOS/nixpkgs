{ lib, stdenv, fetchurl, xorgproto, libXt, libX11
, gifview ? false
, static ? stdenv.hostPlatform.isStatic
}:

with lib;

stdenv.mkDerivation rec {
  pname = "gifsicle";
  version = "1.93";

  src = fetchurl {
    url = "https://www.lcdf.org/gifsicle/${pname}-${version}.tar.gz";
    sha256 = "sha256-kvZweXMr9MHaCH5q4JBSBYRuWsd3ulyqZtEqc6qUNEc=";
  };

  buildInputs = optionals gifview [ xorgproto libXt libX11 ];

  configureFlags = optional (!gifview) "--disable-gifview";

  LDFLAGS = optionalString static "-static";

  doCheck = true;
  checkPhase = ''
    ./src/gifsicle --info logo.gif
  '';

  meta = {
    description = "Command-line tool for creating, editing, and getting information about GIF images and animations";
    homepage = "https://www.lcdf.org/gifsicle/";
    license = lib.licenses.gpl2;
    platforms = platforms.all;
    maintainers = with lib.maintainers; [ zimbatm ];
  };
}
