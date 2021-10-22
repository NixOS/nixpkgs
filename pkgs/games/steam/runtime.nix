{ lib, stdenv, fetchurl

# for update script
, writeShellScript, curl, nix-update
}:

stdenv.mkDerivation rec {

  pname = "steam-runtime";
  # from https://repo.steampowered.com/steamrt-images-scout/snapshots/latest-steam-client-general-availability/VERSION.txt
  version = "0.20210906.1";

  src = fetchurl {
    url = "https://repo.steampowered.com/steamrt-images-scout/snapshots/${version}/steam-runtime.tar.xz";
    sha256 = "1dkynar5y4q0pi32ihdhl7r81v9jxsb7lhc91mqhy43f6462qz1h";
    name = "scout-runtime-${version}.tar.gz";
  };

  buildCommand = ''
    mkdir -p $out
    tar -C $out --strip=1 -x -f $src
  '';

  passthru = {
    updateScript = writeShellScript "update.sh" ''
      version=$(${curl}/bin/curl https://repo.steampowered.com/steamrt-images-scout/snapshots/latest-steam-client-general-availability/VERSION.txt)
      ${nix-update}/bin/nix-update --version "$version" steamPackages.steam-runtime
    '';
  };

  meta = with lib; {
    description = "The official runtime used by Steam";
    homepage = "https://github.com/ValveSoftware/steam-runtime";
    license = licenses.unfreeRedistributable; # Includes NVIDIA CG toolkit
    maintainers = with maintainers; [ hrdinka abbradar ];
  };
}
