{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, libxml2
, systemd
}:

stdenv.mkDerivation {
  pname   = "qdl";
  version = "unstable-2023-04-11";

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "qdl";
    rev = "3b22df2bc7de02d867334af3a7aa8606db4f8cdd";
    sha256 = "sha256-2sL9HX73APTn9nQOx1Efdkz9F4bNASPMVFMx6YOqxyc=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ systemd libxml2 ];

  installPhase = ''
    runHook preInstall
    install -Dm755 ./qdl -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/linux-msm/qdl";
    description = "Tool for flashing images to Qualcomm devices";
    license = licenses.bsd3;
    maintainers = with maintainers; [ muscaln ];
    platforms = platforms.linux;
    mainProgram = "qdl";
  };
}
