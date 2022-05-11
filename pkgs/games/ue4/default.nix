{ lib, stdenv, writeScript, fetchurl, requireFile, unzip, clang, mono, which,
  xorg, xdg-user-dirs }:

let
  deps = import ./cdn-deps.nix { inherit fetchurl; };
  linkDeps = writeScript "link-deps.sh" (lib.concatMapStringsSep "\n" (hash:
    let prefix = lib.concatStrings (lib.take 2 (lib.stringToCharacters hash));
    in ''
      mkdir -p .git/ue4-gitdeps/${prefix}
      ln -s ${lib.getAttr hash deps} .git/ue4-gitdeps/${prefix}/${hash}
    ''
  ) (lib.attrNames deps));
  libPath = lib.makeLibraryPath [
    xorg.libX11 xorg.libXScrnSaver xorg.libXau xorg.libXcursor xorg.libXext
    xorg.libXfixes xorg.libXi xorg.libXrandr xorg.libXrender xorg.libXxf86vm
    xorg.libxcb
  ];
in
stdenv.mkDerivation rec {
  pname = "ue4";
  version = "4.10.2";
  sourceRoot = "UnrealEngine-${version}-release";
  src = requireFile {
    name = "${sourceRoot}.zip";
    url = "https://github.com/EpicGames/UnrealEngine/releases/tag/${version}";
    sha256 = "1rh6r2z00kjzq1i2235py65bg9i482az4rwr14kq9n4slr60wkk1";
  };
  unpackPhase = ''
    ${unzip}/bin/unzip $src
  '';
  configurePhase = ''
    ${linkDeps}

    # Sometimes mono segfaults and things start downloading instead of being
    # deterministic. Let's just fail in that case.
    export http_proxy="nodownloads"

    patchShebangs Setup.sh
    patchShebangs Engine/Build/BatchFiles/Linux
    ./Setup.sh
    ./GenerateProjectFiles.sh
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/UnrealEngine

    sharedir="$out/share/UnrealEngine"

    cat << EOF > $out/bin/UE4Editor
    #! $SHELL -e

    sharedir="$sharedir"

    # Can't include spaces, so can't piggy-back off the other Unreal directory.
    workdir="\$HOME/.config/unreal-engine-nix-workdir"
    if [ ! -e "\$workdir" ]; then
      mkdir -p "\$workdir"
      ${xorg.lndir}/bin/lndir "\$sharedir" "\$workdir"
      unlink "\$workdir/Engine/Binaries/Linux/UE4Editor"
      cp "\$sharedir/Engine/Binaries/Linux/UE4Editor" "\$workdir/Engine/Binaries/Linux/UE4Editor"
    fi

    cd "\$workdir/Engine/Binaries/Linux"
    export PATH="${xdg-user-dirs}/bin\''${PATH:+:}\$PATH"
    export LD_LIBRARY_PATH="${libPath}\''${LD_LIBRARY_PATH:+:}\$LD_LIBRARY_PATH"
    exec ./UE4Editor "\$@"
    EOF
    chmod +x $out/bin/UE4Editor

    cp -r . "$sharedir"
  '';
  buildInputs = [ clang mono which xdg-user-dirs ];

  meta = {
    description = "A suite of integrated tools for game developers to design and build games, simulations, and visualizations";
    homepage = "https://www.unrealengine.com/what-is-unreal-engine-4";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    # See issue https://github.com/NixOS/nixpkgs/issues/17162
    broken = true;
  };
}
