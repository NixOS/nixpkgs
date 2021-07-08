{ stdenv
, fetchFromGitHub
, runCommand
, rustPlatform
, pkgconfig
, makeWrapper
, makeDesktopItem
, alsaLib
, libGL
, libGLU
, libglvnd
, libpthreadstubs
, libSM
, udev
, libX11
, libXaw
, libxcb
, libXcomposite
, libXcursor
, libXdmcp
, libXext
, libXi
, libXinerama
, libXmu
, libXrandr
, libXrender
, libXv
, libXxf86vm
, addOpenGLRunpath
, patchelf
, xorg
, fontconfig
, dbus
}:

let
  pname = "zemeroth";
  version = "0.6.0";
  source = fetchFromGitHub {
    owner = "ozkriff";
    repo = "zemeroth";
    rev = "v${version}";
    sha256 = "0w0g8pv43m9w0plwiwjf3lwz01qisag6apqf9b87x5mgg41a33wi";
  };
  assets = fetchFromGitHub {
    owner = "ozkriff";
    repo = "zemeroth_assets";
    rev = "56b620664a25c8747b33d20f3b91433a0717bcf2";
    sha256 = "0japybbfrdxi3l3xmr1mv3d0jlbnf8461pvhnwb9g9mh9npl5zis";
  };
  desktopFile = makeDesktopItem {
    name = "zemeroth";
    exec = "%out%/bin/zemeroth";
    comment = "A 2d turn-based tactical game";
    desktopName = "Zemeroth";
    categories = "Game;";
  };
  ld_library_path = builtins.concatStringsSep ":" [
    "${stdenv.cc.cc.lib}/lib64"
    (stdenv.lib.makeLibraryPath [
      addOpenGLRunpath.driverLink
    ])
  ];
in

rustPlatform.buildRustPackage rec {
  inherit pname;
  inherit version;

  src =
    runCommand "${pname}-${version}-src" {} ''
      cp -R ${source} $out
      chmod +w $out
      mkdir -p $out/assets
      cp -R ${assets}/* $out/assets/
      cp -R ${assets}/.checksum* $out/assets/
    '';

  cargoBuildFlags = [ "-vv" ];
  # "--cfg feature=\"cargo:rustc-link-search=native=${ld_library_path}\"" ];
  cargoSha256 = "1731cnpwk8108c3vk8c789mb2bvz0wgk1dvl5a3r2v11q35172b4";

  nativeBuildInputs = [
    pkgconfig
    addOpenGLRunpath
    makeWrapper
    patchelf
  ];
  buildInputs = [
    alsaLib
    libGL
    libGLU
    libglvnd
    libpthreadstubs
    libSM
    udev
    libX11
    libXaw
    libxcb
    libXcomposite
    libXcursor
    libXdmcp
    libXext
    libXi
    libXinerama
    libXmu
    libXrandr
    libXrender
    libXv
    libXxf86vm
  ];
  propagatedBuildInputs = [
    libGL
    libGLU
    libglvnd
  ];
  #LD_LIBRARY_PATH = "${ld_library_path}";

  postInstall = ''
    mkdir -p $out/assets
    cp -r ${assets}/* $out/assets/
    wrapProgram $out/bin/zemeroth --set ASSET_DIR_NAME $out/assets
    mkdir -p $out/share/applications
    substituteAll ${desktopFile}/share/applications/zemeroth.desktop $out/share/applications/zemeroth.desktop
    mkdir -p $out/lib
    ln -s /run/opengl-driver/lib/libGLX_mesa.so $out/lib/libGLX.so
  '';

  meta = with stdenv.lib; {
    description = "A 2D turn-based tactical game in Rust";
    homepage = "https://github.com/ozkriff/zemeroth";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ "0x4A6F" ];
    platforms = platforms.linux;
  };
}
