{
  fetchFromSourcehut,
  hareHook,
  lib,
  scdoc,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "himitsu";
  version = "0.7";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "himitsu";
    rev = finalAttrs.version;
    hash = "sha256-jDxQajc8Kyfihm8q3wCpA+WsbAkQEZerLckLQXNhTa8=";
  };

  nativeBuildInputs = [
    hareHook
    scdoc
  ];

  installFlags = [ "PREFIX=${builtins.placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://himitsustore.org/";
    description = "Secret storage manager";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ auchter ];
    inherit (hareHook.meta) platforms badPlatforms;
  };
})
