<<<<<<< HEAD
{ lib, stdenv, buildGoModule, fetchFromGitea, nixosTests }:

buildGoModule rec {
  pname = "eris-go";
  version = "20230729";
=======
{ lib, stdenv, buildGoModule, fetchFromGitea }:

buildGoModule rec {
  pname = "eris-go";
  version = "20230202";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "eris";
<<<<<<< HEAD
    repo = "eris-go";
    rev = version;
    hash = "sha256-yFWmfWmlGL4fC36XsjO/ao/v8FVI20EpXSblZ0EcosI=";
  };

  vendorHash = "sha256-Z6rirsiiBzH0herQAkxZp1Xr++489qNoiD4fqoLt9/A=";

  passthru.tests = { inherit (nixosTests) eris-server; };

  meta = src.meta // {
    description = "Implementation of ERIS for Go";
    homepage = "https://codeberg.org/eris/eris-go";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ehmry ];
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    broken = stdenv.isDarwin;
  };
}
