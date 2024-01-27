{ lib, stdenv, fetchurl

# for update script
, writeShellScript, curl, nix-update
}:

stdenv.mkDerivation rec {

  pname = "steam-runtime";
  # from https://repo.steampowered.com/steamrt-images-scout/snapshots/latest-steam-client-general-availability/VERSION.txt
  version = "0.20220601.1";

  src = fetchurl {
    url = "https://repo.steampowered.com/steamrt-images-scout/snapshots/${version}/steam-runtime.tar.xz";
    sha256 = "sha256-uYauNtbUlvrnATGks7hWy1zt4Y7AEeADrCr1eVylPbY=";
    name = "scout-runtime-${version}.tar.gz";
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

  meta = with lib; {
    description = "The official runtime used by Steam";
    homepage = "https://github.com/ValveSoftware/steam-runtime";
    license = licenses.unfreeRedistributable; # Includes NVIDIA CG toolkit
    maintainers = with maintainers; [ hrdinka abbradar ];
  };
}
