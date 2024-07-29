{ stdenv
, fetchFromGitHub
, lib
, meson
, ninja
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cgif";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "dloebl";
    repo = "cgif";
    rev = "V${finalAttrs.version}";
    sha256 = "sha256-FvqpToIVYblpuRWeEaUA8MA2Bnp9dpqGquylnXevhX4=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = {
    homepage = "https://github.com/dloebl/cgif";
    description = "CGIF, a GIF encoder written in C";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
