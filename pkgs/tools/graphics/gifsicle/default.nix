{ lib, stdenv, fetchurl, xorgproto, libXt, libX11
, gifview ? false
, static ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "gifsicle";
  version = "1.94";

  src = fetchurl {
    url = "https://www.lcdf.org/gifsicle/${pname}-${version}.tar.gz";
    sha256 = "sha256-S8lwBcB4liDedfiZl9PC9wdYxyxhqgou8E96Zxov+Js=";
  };

  buildInputs = lib.optionals gifview [ xorgproto libXt libX11 ];

  configureFlags = lib.optional (!gifview) "--disable-gifview";

  LDFLAGS = lib.optionalString static "-static";

  doCheck = true;
  checkPhase = ''
    ./src/gifsicle --info logo.gif
  '';

  meta = {
    description = "Command-line tool for creating, editing, and getting information about GIF images and animations";
    homepage = "https://www.lcdf.org/gifsicle/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zimbatm ];
  };
}
