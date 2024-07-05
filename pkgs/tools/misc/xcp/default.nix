{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "xcp";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5d0jI2augBYHKM1H8QXDeBJeG3VoNBdfykU5I4E5xu8=";
  };

  # no such file or directory errors
  doCheck = false;

  cargoHash = "sha256-jS4OebCHcg7GG033LairvjXdswKaJI9kg8ycOQmXSME=";

  meta = with lib; {
    description = "Extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lom ];
    mainProgram = "xcp";
  };
}
