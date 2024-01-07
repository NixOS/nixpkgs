{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, IOKit
, nvidiaSupport ? false
, makeWrapper
}:

assert nvidiaSupport -> stdenv.isLinux;

rustPlatform.buildRustPackage rec {
  pname = "zenith";
  version = "0.14.0-unstable-2023-11-21";

  src = fetchFromGitHub {
    owner = "bvaisvil";
    repo = pname;
    rev = "0ed09e6a68c1517b4d050f5e3163421718226040";
    hash = "sha256-vw/ar2Qi06HxPfPsfcxtfRhMTqY4FCE+7tCfe9sLEv0=";
  };

  # remove cargo config so it can find the linker on aarch64-linux
  postPatch = ''
    rm .cargo/config
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "heim-0.1.0-rc.1" = "sha256-TKEG0YxF44wLz+qxpS/VfRKucqyl97t3PDxjPajbD58=";
      "sysinfo-0.15.1" = "sha256-faMxXEHL7DFQLYrAJ+yBL6yiepZotofPF2+SizGQj4A=";
    };
  };

  nativeBuildInputs = [ rustPlatform.bindgenHook ] ++ lib.optional nvidiaSupport makeWrapper;
  buildInputs = lib.optionals stdenv.isDarwin [ IOKit ];

  buildFeatures = lib.optional nvidiaSupport "nvidia";

  postInstall = lib.optionalString nvidiaSupport ''
    wrapProgram $out/bin/zenith \
      --suffix LD_LIBRARY_PATH : "/run/opengl-driver/lib"
  '';

  meta = with lib; {
    description = "Sort of like top or htop but with zoom-able charts, network, and disk usage"
      + lib.optionalString nvidiaSupport ", and NVIDIA GPU usage";
    homepage = "https://github.com/bvaisvil/zenith";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
