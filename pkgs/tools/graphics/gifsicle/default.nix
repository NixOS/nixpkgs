{ stdenv, fetchurl, xorgproto, libXt, libX11, gifview ? false, static ? false }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "gifsicle";
  version = "1.92";

  src = fetchurl {
    url = "https://www.lcdf.org/gifsicle/${pname}-${version}.tar.gz";
    sha256 = "0rffpzxcak19k6cngpxn73khvm3z1gswrqs90ycdzzb53p05ddas";
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
    homepage = https://www.lcdf.org/gifsicle/;
    license = stdenv.lib.licenses.gpl2;
    platforms = platforms.all;
    maintainers = with stdenv.lib.maintainers; [ zimbatm ];
  };
}
