{ stdenv
, fetchFromGitHub
, cmake
, pkg-config
, curl
, alsaLib
, libGLU
, libX11
, libevdev
, udev
, libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "reicast";
  version = "20.04";

  src = fetchFromGitHub {
    owner = "reicast";
    repo = "reicast-emulator";
    rev = "r${version}";
    sha256 = "0vz3b1hg1qj6nycnqq5zcpzqpcbxw1c2ffamia5z3x7rapjx5d71";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    curl
    alsaLib
    libGLU
    libX11
    libevdev
    udev
    libpulseaudio
  ];

  # No rule to make target 'install'
  installPhase = ''
    runHook preInstall

    install -D ./reicast $out/bin/reicast

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = "https://reicast.com/";
    description = "A multi-platform Sega Dreamcast emulator";
    license = with licenses; [ bsd3 gpl2Only lgpl2Only ];
    platforms = ["x86_64-linux" ];
    maintainers = [ maintainers.ivar ];
  };
}
