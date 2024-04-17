{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-md2man";
  version = "2.0.4";

  vendorHash = "sha256-aMLL/tmRLyGze3RSB9dKnoTv5ZK1eRtgV8fkajWEbU0=";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "cpuguy83";
    repo = "go-md2man";
    sha256 = "sha256-pQ+H8Psh92KWTang8hK0cHFLomH+4X0rMMilIJUQ4Qc=";
  };

  meta = with lib; {
    description = "Go tool to convert markdown to man pages";
    mainProgram = "go-md2man";
    license = licenses.mit;
    homepage = "https://github.com/cpuguy83/go-md2man";
    maintainers = with maintainers; [offline];
  };
}
