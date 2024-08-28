{ lib, stdenv, fetchFromGitHub, libX11 }:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcwd";
  version = "1.0";

  src = fetchFromGitHub {
    owner   = "schischi";
    repo    = "xcwd";
    rev     = "v${finalAttrs.version}";
    hash    = "sha256-M6/1H6hI50Cvx40RTKzZXoUui0FGZfwe1IwdaxMJIQo=";
  };

  buildInputs = [ libX11 ];

  makeFlags = [ "prefix=$(out)" ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = {
    description = ''
      A simple tool which prints the current working directory of the currently focused window
    '';
    homepage = "https://github.com/schischi/xcwd";
    license = lib.licenses.bsd3;
    mainProgram = "xcwd";
    maintainers = [ lib.maintainers.grburst ];
    platforms = lib.platforms.linux;
  };
})
