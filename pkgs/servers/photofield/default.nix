{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildGoModule,
  buildNpmPackage,
  makeWrapper,
  exiftool,
  ffmpeg,
  testers,
  photofield,
}:

let
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

buildGoModule {
  pname = "photofield";
  inherit version src;

  patches = [
    # Needed for Go 1.22 build support
    (fetchpatch {
      name = "upgrade-pyroscope-go.patch";
      url = "https://github.com/SmilyOrg/photofield/commit/681dcd48ab4113b0e99fe1a0d3638f0dfe985c05.patch";
      hash = "sha256-JGb5KAI/SmR1kiiaPoSsAF7G4YWDFXj0K3Gjw0zA3Ro=";
    })
  ];

  vendorHash = "sha256-BnImE4wK2MDO21N5tT9Q9w+NkDpdBCEqUwzuH/xb6fg=";

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
      --prefix PATH : "${
        lib.makeBinPath [
          exiftool
          ffmpeg
        ]
      }"
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
