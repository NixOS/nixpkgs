{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "topfew";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "timbray";
    repo = "topfew";
    rev = version;
    hash = "sha256-6ydi/4LyqTLKpR00f4zpcrTnCorlhnsBOxdhzBMNcRI=";
  };

  vendorHash = null;

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    installManPage doc/tf.1
  '';

  meta = with lib; {
    description = "Finds the fields (or combinations of fields) which appear most often in a stream of records";
    homepage = "https://github.com/timbray/topfew";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "tf";
  };
}
