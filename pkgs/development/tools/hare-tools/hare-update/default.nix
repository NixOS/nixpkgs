{
  fetchFromSourcehut,
  hareToolsHook,
  lib,
  stdenv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hare-update";
  version = "0.26.0.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-update";
    tag = finalAttrs.version;
    hash = "sha256-E6N9UMYdNTgy0tppBgOwT14WUXvjliSh/ps16fPDFN8=";
  };

  nativeBuildInputs = [
    hareToolsHook
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Tool for assisting in updating Hare codebases affected by breaking changes";
    longDescription = ''
      hare-update is a Hare add-on which assists in migrating a Hare codebases
      to a newer release of Hare by scanning your code, identifying areas
      impacted by breaking changes, and suggesting the appropriate fix.
    '';
    homepage = "https://git.sr.ht/~sircmpwn/hare-update";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ snifexx ];
    inherit (hareToolsHook.meta) platforms badPlatforms;
  };
})
