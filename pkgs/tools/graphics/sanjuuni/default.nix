{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, pkg-config
, autoreconfHook
, ffmpeg
, poco
, ocl-icd
, opencl-clhpp
}:

stdenv.mkDerivation rec {
  pname = "sanjuuni";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "MCJack123";
    repo = "sanjuuni";
    rev = version;
    sha256 = "sha256-wgtyrik4Z5AXd8MHkiMuxMpGh/xcEtNqivyhvL68aac=";
  };

  patches = [
    (fetchpatch {
      name = "build-with-cxx17.patch";
      url = "https://github.com/MCJack123/sanjuuni/commit/f2164bc18935bcf63ee5b0a82087bc91f7fd258d.patch";
      hash = "sha256-MjDeAiB3WkemCRYzgOHzHlbPUoI4DHEYe28xIIC+c7I=";
      excludes = [ "configure" ]; # conflicts with release tarball; we manually regenerate this
    })
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    ffmpeg
    poco
    ocl-icd
    opencl-clhpp
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 sanjuuni $out/bin/sanjuuni

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/MCJack123/sanjuuni";
    description = "Command-line tool that converts images and videos into a format that can be displayed in ComputerCraft";
    changelog = "https://github.com/MCJack123/sanjuuni/releases/tag/${version}";
    maintainers = [ maintainers.tomodachi94 ];
    license = licenses.gpl2Plus;
    broken = stdenv.isDarwin;
    mainProgram = "sanjuuni";
  };
}
