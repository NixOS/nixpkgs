{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "symfony-cli";
  version = "5.5.6";
  vendorHash = "sha256-AfgDsd4W8wV0GeymD9SLeHtOeFP9qbFy+GTdMxQSkDA=";

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    rev = "v${version}";
    sha256 = "sha256-lE8RBjBXucL0DJjEnBLbHqOVE6g358rwmaEUqU6QhOw=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  postInstall = ''
    mv $out/bin/symfony-cli $out/bin/symfony
  '';

  # Tests requires network access
  checkPhase = ''
    $GOPATH/bin/symfony-cli
  '';

  meta = with lib; {
    description = "Symfony CLI";
    homepage = "https://github.com/symfony-cli/symfony-cli";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ drupol ];
    mainProgram = "symfony";
  };
}
