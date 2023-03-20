{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "zps";
  version = "1.2.8";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "zps";
    rev = version;
    hash = "sha256-t0kVMrJn+eqUUD98pp3iIK28MoLwOplLk0sYgRJkO4c=";
  };

  nativeBuildInputs = [
    cmake
  ];

  postInstall = ''
    mkdir -p $out/share/applications
    substitute ../.application/zps.desktop $out/share/applications/zps.desktop \
      --replace Exec=zps Exec=$out/zps \
  '';

  meta = with lib; {
    description = "A small utility for listing and reaping zombie processes on GNU/Linux";
    homepage = "https://github.com/orhun/zps";
    changelog = "https://github.com/orhun/zps/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    platforms = platforms.linux;
  };
}
