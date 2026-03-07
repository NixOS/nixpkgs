{
  lib,
  buildGoModule,
  fetchurl,
  autoreconfHook,
  pkg-config,
}:

import ./versions.nix (
  {
    version,
    hash,
    ...
  }:
  buildGoModule {
    pname = "zabbix-web-service";
    inherit version;

    src = fetchurl {
      url = "https://cdn.zabbix.com/zabbix/sources/stable/${lib.versions.majorMinor version}/zabbix-${version}.tar.gz";
      inherit hash;
    };

    modRoot = "src/go";

    vendorHash = null;

    nativeBuildInputs = [
      autoreconfHook
      pkg-config
    ];
    buildInputs = [ ];

    # need to provide GO* env variables & patch for reproducibility
    postPatch = ''
      substituteInPlace src/go/Makefile.am \
        --replace-fail '`go env GOOS`' "$GOOS" \
        --replace-fail '`go env GOARCH`' "$GOARCH" \
        --replace-fail '`date +%H:%M:%S`' "00:00:00" \
        --replace-fail '`date +"%b %_d %Y"`' "Jan 1 1970"
    '';

    preConfigure = ''
      ./configure \
        --prefix=${placeholder "out"} \
        --enable-webservice
    '';

    # as stated in agent2.nix, zabbix build process is complex to get
    # right in nix. We again use automake to build the go project
    # ensuring proper access to the go vendor directory
    buildPhase = ''
      cd ../..
      make
    '';

    installPhase = ''
      mkdir -p $out/sbin

      install -Dm0644 src/go/conf/zabbix_web_service.conf $out/etc/zabbix_web_service.conf
      install -Dm0755 src/go/bin/zabbix_web_service $out/bin/zabbix_web_service
    '';

    meta = {
      description = "Enterprise-class open source distributed monitoring solution (web service for generating and sending scheduled reports)";
      homepage = "https://www.zabbix.com/";
      license =
        if (lib.versions.major version >= "7") then lib.licenses.agpl3Only else lib.licenses.gpl2Plus;
      maintainers = with lib.maintainers; [
        aanderse
        bstanderline
        jnclark
      ];
      platforms = lib.platforms.linux;
    };
  }
)
