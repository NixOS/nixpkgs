{ lib
, fetchFromGitHub
, buildGoModule
, buildNpmPackage
, makeWrapper
, exiftool
, ffmpeg
}:

let
  pname = "photofield-ui";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "SmilyOrg";
    repo = "photofield";
    rev = "v${version}";
    hash = "sha256-kcKnE4U+XWYfKw5nZSk+xCtYdagHBMZS3hvukEL8p4M=";
  };

  webui = buildNpmPackage {
    inherit src version;
    pname = "photofield-ui";

    sourceRoot = "source/ui";

    npmDepsHash = "sha256-YVyaZsFh5bolDzMd5rXWrbbXQZBeEIV6Fh/kwN+rvPk=";

    installPhase = ''
      mkdir -p $out/share
      mv dist $out/share/photofield-ui
    '';
  };
in

buildGoModule rec {
  pname = "photofield";
  inherit version src;

  vendorHash = "sha256-g6jRfPALBAgZVuljq/JiCpea7gZl/8akiabxjRmDsFs=";

  preBuild = ''
    cp -r ${webui}/share/photofield-ui ui/dist
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.builtBy=Nix"
  ];

  tags = [ "embedstatic" ];

  doCheck = false; # tries to modify filesytem

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/photofield \
      --prefix PATH : "${lib.makeBinPath [exiftool ffmpeg]}"
  '';

  meta = with lib; {
    description = "Experimental fast photo viewer";
    homepage = "https://github.com/SmilyOrg/photofield";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
