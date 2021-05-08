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
  version = "0.3.0";

  src = fetchFromSourcehut {
    owner = "~mil";
    repo = "lisgd";
    rev = version;
    sha256 = "0g2pwff2c6ipxz83l26kx4rs3vah9qlm4h0n4x1k80mzqzf15hb6";
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
