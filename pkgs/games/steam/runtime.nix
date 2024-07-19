{ lib, stdenv, fetchurl

# for update script
, writeShellScript, curl, nix-update
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "steam-runtime";
  # from https://repo.steampowered.com/steamrt-images-scout/snapshots/latest-steam-client-general-availability/VERSION.txt
  version = "0.20240415.84615";

  src = fetchurl {
    url = "https://repo.steampowered.com/steamrt-images-scout/snapshots/${finalAttrs.version}/steam-runtime.tar.xz";
    hash = "sha256-C8foNnIVA+O4YwuCrIf9N6Lr/GlApPVgZsYgi+3OZUE=";
    name = "scout-runtime-${finalAttrs.version}.tar.gz";
  };

  buildCommand = ''
    mkdir -p $out
    tar -C $out --strip=1 -x -f $src
  '';

  passthru = {
    updateScript = writeShellScript "update.sh" ''
      version=$(${curl}/bin/curl https://repo.steampowered.com/steamrt-images-scout/snapshots/latest-steam-client-general-availability/VERSION.txt)
      ${lib.getExe nix-update} --version "$version" steamPackages.steam-runtime
    '';
  };

  meta = {
    description = "Official runtime used by Steam";
    homepage = "https://github.com/ValveSoftware/steam-runtime";
    license = lib.licenses.unfreeRedistributable; # Includes NVIDIA CG toolkit
    maintainers = with lib.maintainers; [ hrdinka abbradar ];
  };
})
