{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "smu";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "Gottox";
    repo = "smu";
    rev = "v${version}";
    sha256 = "1jm7lhnzjx4q7gcwlkvsbffcy0zppywyh50d71ami6dnq182vvcc";
  };

  # _FORTIFY_SOURCE requires compiling with optimization (-O)
  env.NIX_CFLAGS_COMPILE = "-O";

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "simple markup - markdown like syntax";
    mainProgram = "smu";
    homepage = "https://github.com/Gottox/smu";
    license = licenses.mit;
    maintainers = with maintainers; [ oxzi ];
  };
}

