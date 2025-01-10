{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "frei";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "alexcoder04";
    repo = "frei";
    rev = "v${version}";
    sha256 = "sha256-9CV6B7fRHXl73uI2JRv3RiaFczLHHBOd7/8UoCAwK6w=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "Modern replacement for free";
    homepage = "https://github.com/alexcoder04/frei";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ infinidoge ];
    mainProgram = "frei";
  };
}
