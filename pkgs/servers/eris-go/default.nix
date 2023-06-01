{ lib, stdenv, buildGoModule, fetchFromGitea }:

buildGoModule rec {
  pname = "eris-go";
  version = "20230202";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "eris";
    repo = pname;
    rev = version;
    hash = "sha256-o9FRlUtMk1h8sR+am2gNEQOMgAceRTdRusI4a6ikHUM=";
  };

  vendorHash = "sha256-ZDJm7ZlDBVWLnuC90pOwa608GnuEgy0N/I96vvesZPY=";

  postInstall = "ln -s $out/bin/eris-get $out/bin/eris-put";
  # eris-get is a multicall binary

  meta = src.meta // {
    description = "Implementation of ERIS for Go";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ehmry ];
    mainProgram = "eris-get";
    broken = stdenv.isDarwin;
  };
}
