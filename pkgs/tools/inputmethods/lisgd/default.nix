{ lib
, stdenv
, fetchFromSourcehut
, writeText
, libinput
, libX11
, conf ? null
, patches ? [ ]
}:

stdenv.mkDerivation rec {
  pname = "lisgd";
  version = "0.3.1";

  src = fetchFromSourcehut {
    owner = "~mil";
    repo = "lisgd";
    rev = version;
    sha256 = "sha256-A8SsF5k4GwfVCj8JtodNWoLdPzaA9YsoP5EHHakUguc=";
  };

  inherit patches;

  postPatch = let
    configFile = if lib.isDerivation conf || lib.isPath conf then
      conf
    else
      writeText "config.def.h" conf;
  in lib.optionalString (conf != null) ''
    cp ${configFile} config.def.h
  '';

  buildInputs = [
    libinput
    libX11
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Bind gestures via libinput touch events";
    homepage = "https://git.sr.ht/~mil/lisgd";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dotlambda ];
  };
}
