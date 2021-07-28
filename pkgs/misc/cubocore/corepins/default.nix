{ mkDerivation, lib, fetchFromGitLab, qtbase, libcprime, cmake, ninja }:

mkDerivation rec {
  pname = "corepins";
  version = "4.2.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-H/l/MHHrTmkfznVKUHFAhim8b/arT5SNK5fxTvjsTE4=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    libcprime
  ];

  meta = with lib; {
    description = "A bookmarking app from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/corepins";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
