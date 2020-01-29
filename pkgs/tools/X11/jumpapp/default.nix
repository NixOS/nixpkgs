{ stdenv, lib, perl, pandoc, fetchFromGitHub, xdotool, wmctrl, xprop, nettools }:

stdenv.mkDerivation rec {
  pname = "jumpapp";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "mkropat";
    repo = "jumpapp";
    rev = "v${version}";
    sha256 = "1jrk4mm42sz6ca2gkb6w3dad53d4im4shpgsq8s4vr6xpl3b43ry";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  nativeBuildInputs = [ pandoc perl ];
  buildInputs = [ xdotool wmctrl xprop nettools perl ];
  postFixup = let
    runtimePath = lib.makeBinPath buildInputs;
  in
  ''
    sed -i "2 i export PATH=${runtimePath}:\$PATH" $out/bin/jumpapp
    sed -i "2 i export PATH=${perl}/bin:\$PATH" $out/bin/jumpappify-desktop-entry
  '';

  meta = {
    homepage = https://github.com/mkropat/jumpapp;
    description = "A run-or-raise application switcher for any X11 desktop";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matklad ];
  };
}
