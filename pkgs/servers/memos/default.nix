{ fetchFromGitHub, buildGoModule, jq, buildNpmPackage, lib, makeWrapper }:

let
  version = "0.21.0";
  src = fetchFromGitHub {
    owner = "usememos";
    repo = "memos";
    rev = "v${version}";
    hash = "sha256-CgJe+P6nYc+dWDtngFH19uo+TEdw36nqmYeEgIlxTBU=";
  };

  frontend = buildNpmPackage {
    pname = "memos-web";
    inherit version;

    src = "${src}";

    npmDepsHash = "sha256-uZwFgpAdD3xnXaimu5zGcKWSco4S4Z08+y1e3kPRGf4=";

    postPatch = ''
      cd web
      cp ${./package-lock.json} package-lock.json
      cp ${./package.json} package.json
    '';

    installPhase = ''
      cd web
      cp -r dist $out
    '';
  };
in
buildGoModule rec {
  pname = "memos";
  inherit version src;

  # check will unable to access network in sandbox
  doCheck = false;
  vendorHash = "";

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
