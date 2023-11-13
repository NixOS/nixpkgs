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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "SmilyOrg";
    repo = "photofield";
    rev = "v${version}";
    hash = "sha256-AqOhagqH0wRKjwcRHFVw0izC0DBv9uY3B5MMDBJoFVE=";
  };

  webui = buildNpmPackage {
    inherit src version;
    pname = "photofield-ui";

    sourceRoot = "${src.name}/ui";

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

  vendorHash = "sha256-0rrBHkKZfStwzIv5Us/8Db6z3ZSqassCMWQMpScZq7Y=";

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
