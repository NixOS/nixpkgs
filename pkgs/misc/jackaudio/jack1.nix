{ lib, stdenv, fetchurl, pkg-config

# Optional Dependencies
, alsa-lib ? null, db ? null, libuuid ? null, libffado ? null, celt ? null

, testers
}:

let
  shouldUsePkg = pkg: if pkg != null && lib.meta.availableOn stdenv.hostPlatform pkg then pkg else null;

  optAlsaLib = shouldUsePkg alsa-lib;
  optDb = shouldUsePkg db;
  optLibuuid = shouldUsePkg libuuid;
  optLibffado = shouldUsePkg libffado;
  optCelt = shouldUsePkg celt;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "jack1";
  version = "0.125.0";

  src = fetchurl {
    url = "https://jackaudio.org/downloads/jack-audio-connection-kit-${finalAttrs.version}.tar.gz";
    sha256 = "0i6l25dmfk2ji2lrakqq9icnwjxklgcjzzk65dmsff91z2zva5rm";
  };

  configureFlags = [
    (lib.enableFeature (optLibffado != null) "firewire")
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ optAlsaLib optDb optLibffado optCelt ];
  propagatedBuildInputs = [ optLibuuid ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "JACK audio connection kit";
    homepage = "https://jackaudio.org";
    license = with licenses; [ gpl2 lgpl21 ];
    pkgConfigModules = [ "jack" ];
    platforms = platforms.unix;
  };
})
