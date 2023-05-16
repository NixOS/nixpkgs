{ fetchFromGitHub, buildGoModule, jq, buildNpmPackage, lib, makeWrapper }:

let
<<<<<<< HEAD
  version = "0.13.2";
=======
  version = "0.12.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "usememos";
    repo = "memos";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-lcOZg5mlFPp04ZCm5GDhQfSwE2ahSmGhmdAw+pygK0A=";
=======
    sha256 = "vAY++SHUMBw+jyuu6KFNt62kE5FM8ysGheQwBSOYos8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  frontend = buildNpmPackage {
    pname = "memos-web";
    inherit version;

    src = "${src}/web";

<<<<<<< HEAD
    npmDepsHash = "sha256-36UcHE98dsGvYQWLIc/xgP8Q0IyJ7la0Qoo3lZqUcmw=";
=======
    npmDepsHash = "sha256-vgO5HWbV/oR1GenK9q5a1bhlTSJqtF4HBcQTZ3DqZq8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    postPatch = ''
      cp ${./package-lock.json} package-lock.json
    '';

    installPhase = ''
      cp -r dist $out
    '';
  };
in
buildGoModule rec {
  pname = "memos";
  inherit version src;

  # check will unable to access network in sandbox
  doCheck = false;
<<<<<<< HEAD
  vendorHash = "sha256-UM/xeRvfvlq+jGzWpc3EU5GJ6Dt7RmTbSt9h3da6f8w=";
=======
  vendorSha256 = "sha256-P4OnICBiTAs/uaQgoYNKK50yj/PYntyH/bLihdPv88s=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Inject frontend assets into go embed
  prePatch = ''
    rm -rf server/dist
    cp -r ${frontend} server/dist
  '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = with lib; {
    homepage = "https://usememos.com";
    description = "A lightweight, self-hosted memo hub";
    maintainers = with maintainers; [ indexyz ];
    license = licenses.mit;
  };
}
