{
  lib,
  rustPlatform,
  fetchFromGitHub,
  blueprint-compiler,
  pkg-config,
  wrapGAppsHook4,
  gdk-pixbuf,
  gtk4,
  libdrm,
  vulkan-loader,
  coreutils,
  hwdata,
}:

rustPlatform.buildRustPackage rec {
  pname = "lact";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "ilya-zlobintsev";
    repo = "LACT";
    rev = "v${version}";
    hash = "sha256-Umi+J6RnYgHO30kFPFKhhKtqyzsLVPMkeQPeG3I4jcs=";
  };

  cargoHash = "sha256-CMK8o1Hcs5E+GtP9EgKmAa5fXHsY5PCYuFQh1zf0YE4=";

  nativeBuildInputs = [
    blueprint-compiler
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    gtk4
    libdrm
    vulkan-loader
  ];

  checkFlags = [
    # tries and fails to initialize gtk
    "--skip=app::root_stack::thermals_page::fan_curve_frame::tests::set_get_curve"
  ];

  postPatch = ''
    substituteInPlace lact-daemon/src/server/system.rs \
      --replace 'Command::new("uname")' 'Command::new("${coreutils}/bin/uname")'

    substituteInPlace res/lactd.service \
      --replace ExecStart={lact,$out/bin/lact}

    substituteInPlace res/io.github.lact-linux.desktop \
      --replace Exec={lact,$out/bin/lact}

    pushd $cargoDepsCopy/pciid-parser
    oldHash=$(sha256sum src/lib.rs | cut -d " " -f 1)
    substituteInPlace src/lib.rs --subst-var-by hwdata ${hwdata}
    substituteInPlace .cargo-checksum.json \
      --replace $oldHash $(sha256sum src/lib.rs | cut -d " " -f 1)
    popd
  '';

  postInstall = ''
    install -Dm444 res/lactd.service -t $out/lib/systemd/system
    install -Dm444 res/io.github.lact-linux.desktop -t $out/share/applications
    install -Dm444 res/io.github.lact-linux.png -t $out/share/pixmaps
  '';

  postFixup = ''
    patchelf $out/bin/.lact-wrapped \
      --add-rpath ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  meta = with lib; {
    description = "Linux AMDGPU Controller";
    homepage = "https://github.com/ilya-zlobintsev/LACT";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    platforms = platforms.linux;
    mainProgram = "lact";
  };
}
