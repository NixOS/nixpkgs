{ stdenv, lib, fetchFromGitHub, unzip, meson, ninja, pkg-config, qtbase, qttools, wrapQtAppsHook, luajit }:
let
  data = stdenv.mkDerivation(finalAttrs: {
    pname = "path-of-building-data";
    version = "2.38.4";

    src = fetchFromGitHub {
      owner = "PathOfBuildingCommunity";
      repo = "PathOfBuilding";
      rev = "v${finalAttrs.version}";
      hash = "sha256-fCKOmP0PxhK2trBA1lyE6kf128FrsuCmBrXMIGTIt0U=";
    };

    nativeBuildInputs = [ unzip ];

    buildCommand = ''
      # I have absolutely no idea how this file is generated
      # and I don't think I want to know. The Flatpak also does this.
      unzip -j -d $out $src/runtime-win32.zip lua/sha1.lua

      # Install the actual data
      cp -r $src/src $src/runtime/lua/*.lua $src/manifest.xml $out

      # Pretend this is an official build so we don't get the ugly "dev mode" warning
      substituteInPlace $out/manifest.xml --replace '<Version' '<Version platform="nixos"'
      touch $out/installed.cfg

      # Completely stub out the update check
      chmod +w $out/src/UpdateCheck.lua
      echo 'return "none"' > $out/src/UpdateCheck.lua
    '';
  });
in
stdenv.mkDerivation {
  pname = "path-of-building";
  version = "${data.version}-unstable-2023-04-09";

  src = fetchFromGitHub {
    owner = "ernstp";
    repo = "pobfrontend";
    rev = "9faa19aa362f975737169824c1578d5011487c18";
    hash = "sha256-zhw2PZ6ZNMgZ2hG+a6AcYBkeg7kbBHNc2eSt4if17Wk=";
  };

  nativeBuildInputs = [ meson ninja pkg-config qttools wrapQtAppsHook ];
  buildInputs = [ qtbase luajit luajit.pkgs.lua-curl ];

  installPhase = ''
    runHook preInstall
    install -Dm555 pobfrontend $out/bin/pobfrontend
    runHook postInstall
  '';

  preFixup = ''
    qtWrapperArgs+=(
      --set LUA_PATH "$LUA_PATH"
      --set LUA_CPATH "$LUA_CPATH"
      --chdir "${data}"
    )
  '';

  passthru.data = data;

  meta = {
    description = "Offline build planner for Path of Exile";
    homepage = "https://pathofbuilding.community/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.k900 ];
    mainProgram = "pobfrontend";
    broken = stdenv.isDarwin;  # doesn't find uic6 for some reason
  };
}
