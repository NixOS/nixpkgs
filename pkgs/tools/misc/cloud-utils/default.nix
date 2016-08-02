{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "cloud-utils-0.27";
  src = fetchurl {
    url = "https://launchpad.net/cloud-utils/trunk/0.27/+download/cloud-utils-0.27.tar.gz";
    sha256 = "16shlmg36lidp614km41y6qk3xccil02f5n3r4wf6d1zr5n4v8vd";
  };
  patches = [ ./growpart-util-linux-2.26.patch ];
  buildPhase = ''
    mkdir -p $out/bin
    cp bin/growpart $out/bin/growpart
    sed -i 's|awk|gawk|' $out/bin/growpart
    sed -i 's|sed|gnused|' $out/bin/growpart
  '';
  dontInstall = true;
  dontPatchShebangs = true;

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
