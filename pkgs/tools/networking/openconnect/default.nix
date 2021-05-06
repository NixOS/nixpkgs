{ lib, stdenv, fetchurl, pkg-config, openssl ? null, gnutls ? null, gmp, libxml2, stoken, zlib, fetchgit, darwin, systemd } :

assert (openssl != null) == (gnutls == null);

let

  vpnc-scripts = stdenv.mkDerivation {
    pname = "vpnc-scripts";
    version = "2021-03-31";

    src = fetchgit {
      url = "git://git.infradead.org/users/dwmw2/vpnc-scripts.git";
      rev = "8fff06090ed193c4a7285e9a10b42e6679e8ecf3";
      sha256 = "14bzzpwz7kdmlbx825h6s4jjdml9q6ziyrq8311lp8caql68qdq1";
    };

    buildPhase = ''
      runHook preBuild
      substituteInPlace vpnc-script \
        --replace "/usr/bin/resolvectl" "${systemd}/bin/resolvectl" \
        --replace "/usr/bin/busctl" "${systemd}/bin/busctl" \
        --replace "/sbin/resolvconf" "${systemd}/bin/resolvconf"
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir $out
      cp vpnc-script $out/
      runHook postInstall
    '';
  };

in stdenv.mkDerivation rec {
  pname = "openconnect";
  version = "8.10";

  src = fetchurl {
    urls = [
      "ftp://ftp.infradead.org/pub/openconnect/${pname}-${version}.tar.gz"
    ];
    sha256 = "1cdsx4nsrwawbsisfkldfc9i4qn60g03vxb13nzppr2br9p4rrih";
  };

  outputs = [ "out" "dev" ];

  configureFlags = [
    "--with-vpnc-script=${vpnc-scripts}/vpnc-script"
    "--disable-nls"
    "--without-openssl-version-check"
  ];

  buildInputs = [ openssl gnutls gmp libxml2 stoken zlib ]
    ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.PCSC;
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "VPN Client for Cisco's AnyConnect SSL VPN";
    homepage = "http://www.infradead.org/openconnect/";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ pradeepchhetri tricktron ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
