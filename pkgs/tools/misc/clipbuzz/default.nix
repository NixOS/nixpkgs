{ lib
, stdenv
, fetchFromSourcehut
, libX11
, libXfixes
, zigHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clipbuzz";
  version = "2.0.0";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = "clipbuzz";
    rev = finalAttrs.version;
    hash = "sha256-V5bAZHoScTzFZBPUhPd7xc/c32SXPLAJp+vsc/lCyeI=";
  };

  nativeBuildInputs = [ zigHook ];

  buildInputs = [
    libX11
    libXfixes
  ];

  meta =  {
    description = "Buzz on new X11 clipboard events";
    homepage = "https://git.sr.ht/~cnx/clipbuzz";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.McSinyx ];
  };
})
