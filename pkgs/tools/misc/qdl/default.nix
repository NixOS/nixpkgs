{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, libxml2
, systemd
, libusb1
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname   = "qdl";
  version = "unstable-2024-06-10";

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "qdl";
    rev = "cbd46184d33af597664e08aff2b9181ae2f87aa6";
    sha256 = "sha256-0PeOunYXY0nEEfGFGdguf5+GNN950GhPfMaD8h1ez/8=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ systemd libxml2 libusb1 ];

  installPhase = ''
    runHook preInstall
    install -Dm755 ./qdl -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/linux-msm/qdl";
    description = "Tool for flashing images to Qualcomm devices";
    license = licenses.bsd3;
    maintainers = with maintainers; [ muscaln anas ];
    platforms = platforms.linux;
    mainProgram = "qdl";
  };

  passthru.updateScript = unstableGitUpdater { };
}
