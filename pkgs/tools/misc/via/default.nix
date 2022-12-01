{ lib, fetchurl, appimageTools }:

let
  pname = "via";
  version = "2.0.5";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://github.com/the-via/releases/releases/download/v${version}/via-${version}-linux.AppImage";
    name = "via-${version}-linux.AppImage";
    sha256 = "sha256-APNtzfeV6z8IF20bomcgMq7mwcK1fbDdFF77Xr0UPOs=";
  };
  appimageContents = appimageTools.extractType2 { inherit name src; };
in appimageTools.wrapType2 {
  inherit name src;

  profile = ''
    # Skip prompt to add udev rule.
    # On NixOS you can add this rule with `services.udev.packages = [ pkgs.via ];`.
    export DISABLE_SUDO_PROMPT=1
  '';

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/via-nativia.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/via-nativia.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share

    mkdir -p $out/etc/udev/rules.d
    echo 'KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", TAG+="udev-acl"' > $out/etc/udev/rules.d/92-viia.rules
  '';

  meta = with lib; {
    description = "Yet another keyboard configurator";
    homepage = "https://caniusevia.com/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ emilytrau ];
    platforms = [ "x86_64-linux" ];
  };
}
