{
  lib,
  stdenv,
  fetchFromGitHub,
  libglvnd,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "cnping";
  version = "unstable-2021-04-04";

  src = fetchFromGitHub {
    owner = "cntools";
    repo = "cnping";
    rev = "6b89363e6b79ecbf612306d42a8ef94a5a2f756a";
    sha256 = "sha256-E3Wm5or6C4bHq7YoyaEbtDwyd+tDVYUOMeQrprlmL4A=";
    fetchSubmodules = true;
  };

  buildInputs = [
    libglvnd
    xorg.libXinerama
    xorg.libXext
    xorg.libX11
  ];

  # The "linuxinstall" target won't work for us:
  # it tries to setcap and copy to a FHS directory
  installPhase = ''
    mkdir -p $out/{bin,share/man/man1}
    cp cnping $out/bin/cnping
    cp cnping.1 $out/share/man/man1/cnping.1
  '';

  meta = with lib; {
    description = "Minimal Graphical IPV4 Ping Tool";
    homepage = "https://github.com/cntools/cnping";
    license = with licenses; [
      mit
      bsd3
    ]; # dual licensed, MIT-x11 & BSD-3-Clause
    maintainers = with maintainers; [ ckie ];
    platforms = platforms.linux;
    mainProgram = "cnping";
  };
}
