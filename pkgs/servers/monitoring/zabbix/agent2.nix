{ lib, buildGoModule, fetchurl, autoreconfHook, pkg-config, libiconv, openssl, pcre, zlib }:

import ./versions.nix ({ version, sha256 }:
  buildGoModule {
    pname = "zabbix-agent2";
    inherit version;

    src = fetchurl {
      url = "https://cdn.zabbix.com/zabbix/sources/stable/${lib.versions.majorMinor version}/zabbix-${version}.tar.gz";
      inherit sha256;
    };

    modRoot = "src/go";

    vendorSha256 =
        if "${lib.versions.majorMinor version}" == "5.0" then "1417qi061xc4m55z0vz420fr7qpi24kw5yj9wq7iic92smakgkjn"
        else if "${lib.versions.majorMinor version}" == "5.4" then "17hx0lnxvc4vlsdp7h66x95rwwh5skk3kynphm605klfix4hjs2k"
        else throw "unsupported version ${version} for zabbix-agent2";

    nativeBuildInputs = [ autoreconfHook pkg-config ];
    buildInputs = [ libiconv openssl pcre zlib ];

    inherit (buildGoModule.go) GOOS GOARCH;

    # need to provide GO* env variables & patch for reproducibility
    postPatch = ''
      substituteInPlace src/go/Makefile.am \
        --replace '`go env GOOS`' "$GOOS" \
        --replace '`go env GOARCH`' "$GOARCH" \
        --replace '`date +%H:%M:%S`' "00:00:00" \
        --replace '`date +"%b %_d %Y"`' "Jan 1 1970"
    '';

    # manually configure the c dependencies
    preConfigure = ''
      ./configure \
        --prefix=${placeholder "out"} \
        --enable-agent2 \
        --with-iconv \
        --with-libpcre \
        --with-openssl=${openssl.dev}
    '';

    # zabbix build process is complex to get right in nix...
    # use automake to build the go project ensuring proper access to the go vendor directory
    buildPhase = ''
      cd ../..
      make
    '';

    installPhase = ''
      mkdir -p $out/sbin

      install -Dm0644 src/go/conf/zabbix_agent2.conf $out/etc/zabbix_agent2.conf
      install -Dm0755 src/go/bin/zabbix_agent2 $out/bin/zabbix_agent2

      # create a symlink which is compatible with the zabbixAgent module
      ln -s $out/bin/zabbix_agent2 $out/sbin/zabbix_agentd
    '';

    meta = with lib; {
      description = "An enterprise-class open source distributed monitoring solution (client-side agent)";
      homepage = "https://www.zabbix.com/";
      license = licenses.gpl2Plus;
      maintainers = [ maintainers.aanderse ];
      platforms = platforms.linux;
    };
  })
