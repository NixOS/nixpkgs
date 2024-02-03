{ fetchFromGitHub, buildGoModule, jq, buildNpmPackage, lib, makeWrapper }:

let
  version = "0.13.2";
  src = fetchFromGitHub {
    owner = "usememos";
    repo = "memos";
    rev = "v${version}";
    hash = "sha256-lcOZg5mlFPp04ZCm5GDhQfSwE2ahSmGhmdAw+pygK0A=";
  };

  frontend = buildNpmPackage {
    pname = "memos-web";
    inherit version;

    src = "${src}/web";

    npmDepsHash = "sha256-36UcHE98dsGvYQWLIc/xgP8Q0IyJ7la0Qoo3lZqUcmw=";

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
  vendorHash = "sha256-UM/xeRvfvlq+jGzWpc3EU5GJ6Dt7RmTbSt9h3da6f8w=";

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
    mainProgram = "memos";
  };
}
