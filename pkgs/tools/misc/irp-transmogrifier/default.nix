{ lib
, fetchFromGitHub
, maven
, libxslt
, jre
, makeWrapper
}:

maven.buildMavenPackage rec {
  pname = "irp-transmogrifier";
  version = "1.2.12";

  src = fetchFromGitHub {
    owner = "bengtmartensson";
    repo = "IrpTransmogrifier";
    rev = "Version-${version}";
    hash = "sha256-AqIfdoqb/a2eeyxPwfm5P8QdVG1n6h3x+15ZvFX7s2Y=";
  };

  nativeBuildInputs = [ libxslt jre makeWrapper ];

  mvnHash = "sha256-Pz7T3uzagqjUI/AfzdGX3RorCulrY8ZlVTLyDQhCGDg=";
  mvnParameters = "-Dmaven.gitcommitid.skip=true -Dgit.commit.id=${src.rev}";

  makeFlags = [
    "INSTALLDIR=${placeholder "out"}/share/${pname}"
    "BINLINK=${placeholder "out"}/bin/${pname}"
    "BROWSELINK=${placeholder "out"}/bin/irpbrowse"
  ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  postInstall = ''
    wrapProgram $out/bin/${pname} \
      --prefix PATH : "${lib.makeBinPath [ jre ]}"
  '';

  meta = with lib; {
    description = "Parser for IRP notation protocols, with rendering, code generation, and decoding";
    homepage = "https://github.com/bengtmartensson/IrpTransmogrifier";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mrene ];
    platforms = jre.meta.platforms;
  };
}
