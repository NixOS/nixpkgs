{
  stdenv,
  lib,
  perl,
  pandoc,
  fetchFromGitHub,
  xdotool,
  wmctrl,
  xprop,
  nettools,
}:

stdenv.mkDerivation rec {
  pname = "jumpapp";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "mkropat";
    repo = "jumpapp";
    rev = "v${version}";
    sha256 = "sha256-9sh0+zpDxwqRGC1jUgGTDdSDRdAFsL12mQ/Opwh/UBc=";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  nativeBuildInputs = [
    pandoc
    perl
  ];
  buildInputs = [
    xdotool
    wmctrl
    xprop
    nettools
    perl
  ];
  postFixup =
    let
      runtimePath = lib.makeBinPath buildInputs;
    in
    ''
      sed -i "2 i export PATH=${runtimePath}:\$PATH" $out/bin/jumpapp
      sed -i "2 i export PATH=${perl}/bin:\$PATH" $out/bin/jumpappify-desktop-entry
    '';

  meta = {
    homepage = "https://github.com/mkropat/jumpapp";
    description = "A run-or-raise application switcher for any X11 desktop";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matklad ];
  };
}
