{ stdenv, fetchurl, substituteAll, gawk, gnused }:

stdenv.mkDerivation {
  name = "cloud-utils-0.29";
  src = fetchurl {
    url = "https://launchpad.net/cloud-utils/trunk/0.29/+download/cloud-utils-0.29.tar.gz";
    sha256 = "0z15gs8gmpy5gqxl7yiyjj7a6s8iw44djj6axvbci627b9pvd8cy";
  };
  buildPhase = ''
    mkdir -p $out/bin
    cp bin/growpart $out/bin/growpart
    substituteInPlace $out/bin/growpart --replace awk ${gawk}/bin/gawk
    substituteInPlace $out/bin/growpart --replace sed ${gnused}/bin/sed
  '';
  dontInstall = true;
  dontPatchShebangs = true;
  dontStrip = true;
}
