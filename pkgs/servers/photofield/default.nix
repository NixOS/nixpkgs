{ lib
, fetchFromGitHub
, buildGoModule
, buildNpmPackage
, makeWrapper
, exiftool
, ffmpeg
, testers
, photofield
}:

let
  pname = "photofield-ui";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "SmilyOrg";
    repo = "photofield";
    rev = "refs/tags/v${version}";
    hash = "sha256-6pJvOn3sN6zfjt2dVZ/xH6pSXM0WgbG7au9tSVUGYys=";
  };

  webui = buildNpmPackage {
    inherit src version;
    pname = "photofield-ui";

    sourceRoot = "${src.name}/ui";

    npmDepsHash = "sha256-trKcNuhRdiabFKMafOLtPg8x1bQHLOif6Hm4k5bTAYc=";

    installPhase = ''
      mkdir -p $out/share
      mv dist $out/share/photofield-ui
    '';
  };
in

buildGoModule rec {
  pname = "photofield";
  inherit version src;

  vendorHash = "sha256-4JFP3vs/Z8iSKgcwfxpdnQpO9kTF68XQArFHYP8IoDQ=";

  preBuild = ''
    cp -r ${webui}/share/photofield-ui ui/dist
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.builtBy=Nix"
  ];

  tags = [ "embedui" ];

  doCheck = false; # tries to modify filesytem

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/photofield \
      --prefix PATH : "${lib.makeBinPath [exiftool ffmpeg]}"
  '';

  passthru.tests.version = testers.testVersion {
    package = photofield;
    command = "photofield -version";
  };

  meta = with lib; {
    description = "Experimental fast photo viewer";
    homepage = "https://github.com/SmilyOrg/photofield";
    license = licenses.mit;
    mainProgram = "photofield";
    maintainers = with maintainers; [ dit7ya ];
  };
}
