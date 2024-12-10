{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  pantheon,
  python3,
  libgee,
  gtk3,
  desktop-file-utils,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "hashit";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "artemanufrij";
    repo = pname;
    rev = version;
    sha256 = "1s8fbzg1z2ypn55xg1pfm5xh15waq55fkp49j8rsqiq8flvg6ybf";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    vala
    pkg-config
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libgee
    pantheon.granite
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A simple app for checking usual checksums - Designed for elementary OS";
    homepage = "https://github.com/artemanufrij/hashit";
    license = licenses.gpl2Plus;
    maintainers = teams.pantheon.members;
    platforms = platforms.linux;
    mainProgram = "com.github.artemanufrij.hashit";
  };
}
