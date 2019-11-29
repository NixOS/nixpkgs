{ stdenv, lib, perl, pandoc, fetchFromGitHub, xdotool, wmctrl, xprop, nettools }:

stdenv.mkDerivation rec {
  pname = "jumpapp";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "mkropat";
    repo = "jumpapp";
    rev = "v${version}";
    sha256 = "11ibh51q4vcjkz9fqyw5dy9qrkqxm42hpdccas1s6h2dk9z62kfb";
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
