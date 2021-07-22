{ mkDerivation, lib, fetchFromGitLab, qtsvg, qtbase, libcsys, libcprime, cmake, ninja, }:

mkDerivation rec {
  pname = "coreaction";
  version = "4.2.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5qEZNLvbgLoAOXij0wXoVw2iyvytsYZikSJDm6F6ddc=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtsvg
    qtbase
    libcsys
    libcprime
  ];

  meta = with lib; {
    description = "A side bar for showing widgets from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/coreaction";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
