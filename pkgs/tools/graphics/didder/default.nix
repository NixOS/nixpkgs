{ lib, stdenv, buildGoModule, fetchFromGitHub, pandoc }:

buildGoModule rec {
  pname = "didder";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "makew0rld";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-S1j2TdV0XCrSc7Ua+SdY3JJoWgnFuAMGhUinTKO2Xh4=";
  };

  vendorHash = "sha256-TEp1YrQquqdEMVvZaNsEB1H/DZsTYmRL257RjQF2JqM=";

  nativeBuildInputs = [ pandoc ];

  postBuild = ''
    make man
  '';

  postInstall = ''
    mkdir -p $out/share/man/man1
    gzip -c didder.1 > $out/share/man/man1/didder.1.gz
  '';

  meta = src.meta // {
    description =
      "An extensive, fast, and accurate command-line image dithering tool";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
