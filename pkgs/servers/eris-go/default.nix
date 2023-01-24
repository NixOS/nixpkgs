{ lib, buildGoModule, fetchFromGitea }:

buildGoModule rec {
  pname = "eris-go";
  version = "20230114";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "eris";
    repo = pname;
    rev = version;
    hash = "sha256-cJvSIeS9fKUJP5p7ZTH7Wi+UcBXeCS32Twhv6jBT+9Q=";
  };

  vendorHash = "sha256-DDV7LUnGnf24qQ2I9I4MDUx87s1+yDhisVz/Jw4XU6k=";

  postInstall = "ln -s $out/bin/eris-get $out/bin/eris-put";
  # eris-get is a multicall binary

  meta = src.meta // {
    description = "Implementation of ERIS for Go";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ehmry ];
    mainProgram = "eris-get";
  };
}
