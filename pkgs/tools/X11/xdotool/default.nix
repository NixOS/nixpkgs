{ stdenv, fetchurl, libX11, perl, libXtst, xextproto, libXi }:

let version = "2.20101012.3049"; in
stdenv.mkDerivation {
  name = "xdotool-${version}";
  src = fetchurl {
    url = "http://semicomplete.googlecode.com/files/xdotool-${version}.tar.gz";
    sha256 = "0amkb1zvdk0gj7va3rjw9arbyj8pgprkdik05yl6rghq21q076ls";
  };

  buildInputs = [ libX11 perl libXtst xextproto libXi ];

  configurePhase = ''
    export makeFlags="PREFIX=$out";
  '';

  meta = {
    homepage = http://www.semicomplete.com/projects/xdotool/;
    description = "Fake keyboard/mouse input, window management, and more";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
