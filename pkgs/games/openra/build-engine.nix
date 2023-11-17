{ lib, buildDotnetModule, dotnetCorePackages
, fetchFromGitHub
, SDL2, freetype, openal, lua51Packages
}:
engine:

buildDotnetModule rec {
  pname = "openra-${engine.build}";
  inherit (engine) version;

  src = if engine ? src then engine.src else fetchFromGitHub {
    owner = "OpenRA";
    repo = "OpenRA";
    rev = "${engine.build}-${engine.version}";
    sha256 = engine.sha256;
  };

  nugetDeps = engine.deps;

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;

  useAppHost = false;

  dotnetFlags = [ "-p:Version=0.0.0.0" ]; # otherwise dotnet build complains, version is saved in VERSION file anyway

  dotnetBuildFlags = [ "-p:TargetPlaform=unix-generic" ];
  dotnetInstallFlags = [
    "-p:TargetPlaform=unix-generic"
    "-p:CopyGenericLauncher=True"
    "-p:CopyCncDll=True"
    "-p:CopyD2kDll=True"
    "-p:UseAppHost=False"
  ];

  dontDotnetFixup = true;

  preBuild = ''
    make VERSION=${engine.build}-${version} version
  '';

  postInstall = ''
    # Create the file so that the install_data script will not attempt to download it.
    # TODO: fetch the file and include it
    touch './IP2LOCATION-LITE-DB1.IPV6.BIN.ZIP'

    # Install all the asset data
    (
      . ./packaging/functions.sh
      install_data . "$out/lib/${pname}" cnc d2k ra
    )

    # Replace precompiled libraries with links to native one.
    # This is similar to configure-system-libraries.sh in the source repository
    ln -s -f ${lua51Packages.lua}/lib/liblua.so $out/lib/${pname}/lua51.so
    ln -s -f ${SDL2}/lib/libSDL2.so             $out/lib/${pname}/SDL2.so
    ln -s -f ${openal}/lib/libopenal.so         $out/lib/${pname}/soft_oal.so
    ln -s -f ${freetype}/lib/libfreetype.so     $out/lib/${pname}/freetype6.so
  '';

  postFixup = ''
    (
      . ./packaging/functions.sh
      install_linux_shortcuts . "" "$out/lib/${pname}" "$out/.bin-unwrapped" "$out/share" "${version}" cnc d2k ra
    )

    # Create Nix wrappers to the application scripts which setup the needed environment
    for bin in $(find $out/.bin-unwrapped -type f); do
      makeWrapper "$bin" "$out/bin/$(basename "$bin")" \
        --prefix "PATH" : "${lib.makeBinPath [ dotnet-runtime ]}"
    done
  '';

  meta = with lib; {
    description = "Open Source real-time strategy game engine for early Westwood games such as Command & Conquer: Red Alert. ${engine.build} version.";
    homepage = "https://www.openra.net/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mdarocha ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "openra-ra";
  };
}
