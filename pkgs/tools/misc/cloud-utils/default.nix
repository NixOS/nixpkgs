{ stdenv, fetchurl, makeWrapper, gawk, gnused, utillinux }:

stdenv.mkDerivation {
  # NOTICE: if you bump this, make sure to run
  # $ nix-build nixos/release-combined.nix -A nixos.tests.ec2-nixops
  name = "cloud-utils-0.29";
  src = fetchurl {
    url = "https://launchpad.net/cloud-utils/trunk/0.29/+download/cloud-utils-0.29.tar.gz";
    sha256 = "0z15gs8gmpy5gqxl7yiyjj7a6s8iw44djj6axvbci627b9pvd8cy";
  };
  buildInputs = [ makeWrapper ];
  buildPhase = ''
    mkdir -p $out/bin
    cp bin/growpart $out/bin/growpart
    sed -i 's|awk|gawk|' $out/bin/growpart
    sed -i 's|sed|gnused|' $out/bin/growpart
    ln -s sed $out/bin/gnused
    wrapProgram $out/bin/growpart --prefix PATH : "${stdenv.lib.makeBinPath [ gnused gawk utillinux ]}:$out/bin"
  '';
  dontInstall = true;
  dontPatchShebangs = true;
  dontStrip = true;

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
