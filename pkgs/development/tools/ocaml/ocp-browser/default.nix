{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  cppo,
  ocp-index,
  cmdliner,
  re,
  lambda-term,
  zed,
}:

buildDunePackage (finalAttrs: {
  pname = "ocp-browser";
  version = "1.4.0";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocp-index";
    tag = finalAttrs.version;
    hash = "sha256-pv6aBJjRkibISpZEnlfyn72smcYEbZoPQoQH2p/JwH0=";
  };

  nativeBuildInputs = [ cppo ];
  propagatedBuildInputs = [
    cmdliner
    lambda-term
    ocp-index
    re
    zed
  ];

  meta = {
    homepage = "https://github.com/OCamlPro/ocp-index";
    description = "Console browser for the documentation of installed OCaml libraries";
    changelog = "https://github.com/OCamlPro/ocp-index/raw/${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ redianthus ];
    mainProgram = "ocp-browser";
  };
})
