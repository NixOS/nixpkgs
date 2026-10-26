{
  lib,
  mkTclDerivation,
  fetchFromGitHub,
  cmark-gfm,
  pkg-config,
}:

mkTclDerivation (finalAttrs: {
  pname = "tcl-cmark";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "apnadkarni";
    repo = "tcl-cmark";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jvtvmbpttQlfLQfhhTpHn6q492DU51k0QJr/8omXhuY=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    cmark-gfm
  ];

  tclRequiresCheck = [
    "cmark"
  ];

  doInstallCheck = true;
  installCheckTarget = "test";

  meta = {
    description = "Tcl bindings to the cmark-gfm Github Flavoured CommonMark/Markdown library";
    homepage = "https://github.com/apnadkarni/tcl-cmark";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fgaz ];
  };
})
