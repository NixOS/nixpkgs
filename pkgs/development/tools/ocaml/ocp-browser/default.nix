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

buildDunePackage rec {
  pname = "ocp-browser";
  version = "1.4.0";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocp-index";
    tag = version;
    hash = "sha256-pv6aBJjRkibISpZEnlfyn72smcYEbZoPQoQH2p/JwH0=";
  };

  strictDeps = true;

  nativeBuildInputs = [ cppo ];
  buildInputs = [
    cmdliner
    lambda-term
    ocp-index
    re
    zed
  ];

  meta = {
    homepage = "https://github.com/OCamlPro/ocp-index";
    description = "Console browser for the documentation of installed OCaml libraries";
    changelog = "https://github.com/OCamlPro/ocp-index/raw/${version}/CHANGES.md";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ redianthus ];
  };
}
