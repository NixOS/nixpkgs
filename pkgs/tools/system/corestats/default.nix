{ mkDerivation, lib, fetchFromGitLab, qtbase, libcprime, libcsys, lm_sensors, cmake, ninja }:

mkDerivation rec {
  pname = "corestats";
  version = "4.2.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/WBetvbd8e4v+j6e2xbGtSLwNMdLlaahSIks6r889B4=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    libcprime
    libcsys
    lm_sensors
  ];

  meta = with lib; {
    description = "A system resource viewer from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/corestats";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
