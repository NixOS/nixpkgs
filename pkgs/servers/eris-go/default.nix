{ lib, buildGoModule, fetchFromGitea }:

buildGoModule rec {
  pname = "eris-go";
  version = "20230123";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "eris";
    repo = pname;
    rev = version;
    hash = "sha256-jdeh5lhbu2hxVNdnU0GiMsdXRi8004Xgu2/tgFhqPao=";
  };

  vendorHash = "sha256-mLyPaX5rDw0rR4PXtzpLMOrsYwTH3Y+COcrvwH7/qdo=";

  postInstall = "ln -s $out/bin/eris-get $out/bin/eris-put";
  # eris-get is a multicall binary

  meta = src.meta // {
    description = "Implementation of ERIS for Go";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ehmry ];
    mainProgram = "eris-get";
  };
}
