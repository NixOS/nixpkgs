{ lib, stdenv, fetchFromGitHub, libX11 }:

stdenv.mkDerivation rec {
  version = "1.0";
  pname = "xcwd";

  src = fetchFromGitHub {
    owner   = "schischi";
    repo    = "xcwd";
    rev     = "v${version}";
    sha256  = "sha256-M6/1H6hI50Cvx40RTKzZXoUui0FGZfwe1IwdaxMJIQo=";
  };

  buildInputs = [ libX11 ];

  makeFlags = [ "prefix=$(out)" ];

  installPhase = ''
    install -D xcwd "$out/bin/xcwd"
  '';

  meta = with lib; {
    description = ''
      A simple tool which print the current working directory of the currently focused window
    '';
    homepage = "https://github.com/schischi/xcwd";
    maintainers = [ maintainers.grburst ];
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
