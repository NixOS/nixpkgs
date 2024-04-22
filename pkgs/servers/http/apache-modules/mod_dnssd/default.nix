{ lib, stdenv, fetchurl, fetchpatch, pkg-config, apacheHttpd, apr, avahi }:

stdenv.mkDerivation rec {
  pname = "mod_dnssd";
  version = "0.6";

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/mod_dnssd/${pname}-${version}.tar.gz";
    sha256 = "2cd171d76eba398f03c1d5bcc468a1756f4801cd8ed5bd065086e4374997c5aa";
  };

  configureFlags = [ "--disable-lynx" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ apacheHttpd avahi apr ];

  patches = [ (fetchpatch {
    url = "http://bazaar.launchpad.net/~ubuntu-branches/ubuntu/vivid/mod-dnssd/vivid/download/package-import%40ubuntu.com-20130530193334-kqebiy78q534or5k/portforapache2.4.pat-20130530222510-7tlw5btqchd04edb-3/port-for-apache2.4.patch";
    sha256 = "1hgcxwy1q8fsxfqyg95w8m45zbvxzskf1jxd87ljj57l7x1wwp4r";
  }) ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/modules
    cp src/.libs/mod_dnssd.so $out/modules

    runHook postInstall
  '';

  preFixup = ''
    # TODO: Packages in non-standard directories not stripped.
    # https://github.com/NixOS/nixpkgs/issues/141554
    stripDebugList=modules
  '';

  meta = with lib; {
    homepage = "https://0pointer.de/lennart/projects/mod_dnssd";
    description = "Provide Zeroconf support via DNS-SD using Avahi";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
