{ stdenv, steamArch, fetchurl, }:

stdenv.mkDerivation rec {

  name = "steam-runtime";
  # from https://repo.steampowered.com/steamrt-images-scout/snapshots/
  version = "0.20200417.0";

  src =
    if steamArch == "amd64" then fetchurl {
      url = "https://repo.steampowered.com/steamrt-images-scout/snapshots/${version}/com.valvesoftware.SteamRuntime.Platform-amd64,i386-scout-runtime.tar.gz";
      sha256 = "0kps8i5v23sycqm69xz389n8k831jd7ncsmlrkky7nib2q91rbvj";
      name = "scout-runtime-${version}.tar.gz";
    } else fetchurl {
      url = "https://repo.steampowered.com/steamrt-images-scout/snapshots/${version}/com.valvesoftware.SteamRuntime.Platform-i386-scout-runtime.tar.gz";
      sha256 = "03fhac1r25xf7ia2pd35wjw360v5pa9h4870yrhhygp9h7v4klzf";
      name = "scout-runtime-i386-${version}.tar.gz";
    };

  buildCommand = ''
    mkdir -p $out
    tar -C $out -x --strip=1 -f $src files/
  '';

  meta = with stdenv.lib; {
    description = "The official runtime used by Steam";
    homepage = "https://github.com/ValveSoftware/steam-runtime";
    license = licenses.unfreeRedistributable; # Includes NVIDIA CG toolkit
    maintainers = with maintainers; [ hrdinka abbradar ];
  };
}
