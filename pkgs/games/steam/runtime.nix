{
  lib,
  stdenv,
  fetchurl,

  # for update script
  writeShellScript,
  curl,
  nix-update,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "steam-runtime";
  # from https://repo.steampowered.com/steamrt-images-scout/snapshots/latest-steam-client-general-availability/VERSION.txt
  version = "0.20231127.68515";

  src = fetchurl {
    url = "https://repo.steampowered.com/steamrt-images-scout/snapshots/${finalAttrs.version}/steam-runtime.tar.xz";
    hash = "sha256-invUOdJGNhrswsj9Vj/bSAkEigWtBQ554sBAyvPf0mk=";
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
    description = "The official runtime used by Steam";
    homepage = "https://github.com/ValveSoftware/steam-runtime";
    license = lib.licenses.unfreeRedistributable; # Includes NVIDIA CG toolkit
    maintainers = with lib.maintainers; [
      hrdinka
      abbradar
    ];
  };
})
