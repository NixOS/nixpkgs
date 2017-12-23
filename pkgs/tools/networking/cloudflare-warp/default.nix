{ fetchurl, stdenv }:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

let
  version = "2017.12.1";
in let
  cloudflare-warp = stdenv.mkDerivation rec {
    name = "cloudflare-warp-${version}-bin";

    src =
      if stdenv.system == "i686-linux" then
        fetchurl {
          name = "${name}.tgz";
          url = "https://bin.equinox.io/c/2ovkwS9YHaP/warp-stable-linux-386.tgz";
          sha256 = "0cvd0jfvw1jcslx07avvsmykbr283n27q790mc0jhwdxqli7qvdl";
        }
      else
        fetchurl {
          name = "${name}.tgz";
          url = "https://bin.equinox.io/c/2ovkwS9YHaP/warp-stable-linux-amd64.tgz";
          sha256 = "0srd0wp87ycg7nzkx1cpyhyz0r2nbz3kccqbnx9wp5ix3gxlsdj7";
        };

    buildCommand = ''
      tar xvf ${src}
      mkdir -p $out/bin
      mv cloudflare-warp $out/bin/cloudflare-warp
      patchelf --shrink-rpath $out/bin/cloudflare-warp
      strip $out/bin/cloudflare-warp
    '';

    meta = with stdenv.lib; {
      description = "Exposes applications running on your local web server";
      longDescription = "Exposes applications running on your local web server, on any network with an Internet connection without adding DNS records, configuring the firewall, configuring the router or opening ports.";
      homepage = "https://warp.cloudflare.com/";
      maintainers = with maintainers; [ lezed1 ];
      license = licenses.unfree;
    };
  };
in stdenv.mkDerivation {
  name = "cloudflare-warp-${version}";

  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    echo $(< $NIX_CC/nix-support/dynamic-linker) ${cloudflare-warp}/bin/cloudflare-warp \"\$@\" > $out/bin/cloudflare-warp
    chmod +x $out/bin/cloudflare-warp
  '';

  meta = cloudflare-warp.meta;
}
