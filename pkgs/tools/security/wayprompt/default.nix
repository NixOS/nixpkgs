{ pkgs
, lib
, stdenv
, fetchFromSourcehut
, zig
, wayland
, pkg-config
, wayland-protocols
, fcft
, libxkbcommon
, pixman
}:

stdenv.mkDerivation {
  pname = "wayprompt-unstable";
  version = "2022-09-27";
  src = fetchFromSourcehut {
    owner = "~leon_plickat";
    repo = "wayprompt";
    rev = "8a6fe7d1d3e8fb6cb54733a0cb10be521c0a72b4";
    sha256 = "sha256-CylSDPp4gWVmqEe7xuPWINf8cLs1iqi8FYXyY6yGYlo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ zig wayland pkg-config ];

  buildInputs = [ wayland-protocols fcft libxkbcommon pixman ];

  dontConfigure = true;

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    runHook preInstall
    zig build --prefix $out
    ln -sf wayprompt $out/bin/pinentry-wayprompt
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~leon_plickat/wayprompt";
    description = "Multi-purpose prompt tool for Wayland";
    license = licenses.gpl3;
    platforms = platforms.linux;
    longDescription = ''
      wayprompt provides a multi-purpose prompt tool for Wayland.
    '';
    maintainers = with maintainers; [ abbe ];
  };
}
