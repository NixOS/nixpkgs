{ lib, buildGoModule, fetchFromGitHub, makeWrapper, go }:

buildGoModule rec {
  pname = "cobra-cli";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "spf13";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-E0I/Pxw4biOv7aGVzGlQOFXnxkc+zZaEoX1JmyMh6UE=";
  };

  vendorSha256 = "sha256-vrtGPQzY+NImOGaSxV+Dvch+GNPfL9XfY4lfCHTGXwY=";

  nativeBuildInputs = [ makeWrapper ];

  allowGoReference = true;

  postPatch = ''
    substituteInPlace "cmd/add_test.go" \
      --replace "TestGoldenAddCmd" "SkipGoldenAddCmd"
    substituteInPlace "cmd/init_test.go" \
      --replace "TestGoldenInitCmd" "SkipGoldenInitCmd"
  '';

  postFixup = ''
    wrapProgram "$out/bin/cobra-cli" \
      --prefix PATH : ${go}/bin
  '';

  meta = with lib; {
    description = "Cobra CLI tool to generate applications and commands";
    homepage = "https://github.com/spf13/cobra-cli/";
    changelog = "https://github.com/spf13/cobra-cli/releases/tag/${version}";
    license = licenses.afl20;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
