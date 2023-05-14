{ fetchFromGitHub, buildGoModule, jq, buildNpmPackage, lib, makeWrapper }:

let
  version = "0.12.2";
  src = fetchFromGitHub {
    owner = "usememos";
    repo = "memos";
    rev = "v${version}";
    sha256 = "vAY++SHUMBw+jyuu6KFNt62kE5FM8ysGheQwBSOYos8=";
  };

  frontend = buildNpmPackage {
    pname = "memos-web";
    inherit version;

    src = "${src}/web";

    npmDepsHash = "sha256-vgO5HWbV/oR1GenK9q5a1bhlTSJqtF4HBcQTZ3DqZq8=";

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
  vendorSha256 = "sha256-P4OnICBiTAs/uaQgoYNKK50yj/PYntyH/bLihdPv88s=";

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
