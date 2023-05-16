<<<<<<< HEAD
{ lib, stdenv, libX11, libXtst, libXext, fetchFromGitHub, autoreconfHook, pkg-config, libXi }:

stdenv.mkDerivation rec {
  pname = "x2x";
  version = "unstable-2023-04-30";

  src = fetchFromGitHub {
    owner = "dottedmag";
    repo = pname;
    rev = "53692798fa0e991e0dd67cdf8e8126158d543d08";
    hash = "sha256-FUl2z/Yz9uZlUu79LHdsXZ6hAwSlqwFV35N+GYDNvlQ=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libX11 libXtst libXext libXi ];
=======
{ lib, stdenv, fetchurl, imake, libX11, libXtst, libXext, gccmakedep }:

stdenv.mkDerivation rec {
  pname = "x2x";
  version = "1.27";

  src = fetchurl {
    url = "https://github.com/downloads/dottedmag/x2x/x2x-${version}.tar.gz";
    sha256 = "0dha0kn1lbc4as0wixsvk6bn4innv49z9a0sm5wlx4q1v0vzqzyj";
  };

  nativeBuildInputs = [ imake gccmakedep ];
  buildInputs = [ libX11 libXtst libXext ];

  hardeningDisable = [ "format" ];

  buildFlags = [ "x2x" ];

  installPhase = ''
    install -D x2x $out/bin/x2x
    install -D x2x.1 $out/man/man1/x2x.1
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Allows the keyboard, mouse on one X display to be used to control another X display";
    homepage = "https://github.com/dottedmag/x2x";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
