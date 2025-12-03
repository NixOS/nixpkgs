{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  apacheHttpd,
  apr,
  avahi,
}:

stdenv.mkDerivation rec {
  pname = "mod_dnssd";
  version = "0.6";

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/mod_dnssd/${pname}-${version}.tar.gz";
    sha256 = "2cd171d76eba398f03c1d5bcc468a1756f4801cd8ed5bd065086e4374997c5aa";
  };

  configureFlags = [
    "--disable-lynx"
    "--with-apxs=${lib.getDev apacheHttpd}/bin"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    apacheHttpd
    avahi
    apr
  ];

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/m/mod-dnssd/0.6-5/debian/patches/port-for-apache2.4.patch";
      hash = "sha256-jWWzZDpZdveXlLpo7pN0tMQZkjYUbpz/DRjm6T6pCzY=";
    })
  ];

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
    maintainers = [ ];
  };
}
