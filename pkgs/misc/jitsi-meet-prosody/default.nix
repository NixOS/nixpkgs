{ lib, stdenv, fetchurl, dpkg, nixosTests }:

stdenv.mkDerivation rec {
  pname = "jitsi-meet-prosody";
  version = "1.0.5056";
  src = fetchurl {
    url = "https://download.jitsi.org/stable/${pname}_${version}-1_all.deb";
    sha256 = "06qxa9h2ry92xrk2jklp76nv3sl8nvykdvsqmhn33lz6q6vmw2xr";
  };

  dontBuild = true;

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $src debcontents";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share
    mv usr/share/jitsi-meet/prosody-plugins $out/share/
    runHook postInstall
  '';

  passthru.tests = {
    single-node-smoke-test = nixosTests.jitsi-meet;
  };

  meta = with lib; {
    description = "Prosody configuration for Jitsi Meet";
    longDescription = ''
        This package contains configuration for Prosody to be used with Jitsi Meet.
    '';
    homepage = "https://github.com/jitsi/jitsi-meet/";
    license = licenses.asl20;
    maintainers = teams.jitsi.members;
    platforms = platforms.linux;
  };
}
