{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, ffmpeg
, poco
<<<<<<< HEAD
, ocl-icd
, opencl-clhpp
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "sanjuuni";
<<<<<<< HEAD
  version = "0.4";
=======
  version = "0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "MCJack123";
    repo = "sanjuuni";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-wgtyrik4Z5AXd8MHkiMuxMpGh/xcEtNqivyhvL68aac=";
=======
    sha256 = "sha256-8IbdLXWUtT2VN6Eu1b8x4DnyI8JOd/12t0XDa6o3N+A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ffmpeg
    poco
<<<<<<< HEAD
    ocl-icd
    opencl-clhpp
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 sanjuuni $out/bin/sanjuuni

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/MCJack123/sanjuuni";
    description = "A command-line tool that converts images and videos into a format that can be displayed in ComputerCraft";
    changelog = "https://github.com/MCJack123/sanjuuni/releases/tag/${version}";
    maintainers = [ maintainers.tomodachi94 ];
    license = licenses.gpl2Plus;
    broken = stdenv.isDarwin;
  };
}
