{ lib
, gccStdenv
, fetchFromGitHub
, autoreconfHook
, xorgproto
, libX11
, libXpm
}:

gccStdenv.mkDerivation rec {
  pname = "0verkill";
  version = "unstable-2011-01-13";

  src = fetchFromGitHub {
    owner = "hackndev";
    repo = pname;
    rev = "522f11a3e40670bbf85e0fada285141448167968";
    sha256 = "WO7PN192HhcDl6iHIbVbH7MVMi1Tl2KyQbDa9DWRO6M=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libX11 xorgproto libXpm ];

  configureFlags = [ "--with-x" ];

  preAutoreconf = ''
    autoupdate
  '';

  hardeningDisable = [ "all" ]; # Someday the upstream will update the code...

  meta = with lib; {
    homepage = "https://github.com/hackndev/0verkill";
    description = "ASCII-ART bloody 2D action deathmatch-like game";
    license = with licenses; gpl2Only;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
