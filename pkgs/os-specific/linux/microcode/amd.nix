{ stdenv, fetchurl }:

stdenv.mkDerivation rec {

  name = "amd-ucode-2012-09-10";

  src = fetchurl {
    #url = "http://www.amd64.org/pub/microcode/${name}.tar"; # www.amd64.org is often down
    #url="http://pkgs.fedoraproject.org/repo/pkgs/microcode_ctl/amd-ucode-2012-09-10.tar/559bc355d3799538584add80df2996f0/${name}.tar";

    urls = [ "http://www.amd64.org/pub/microcode/${name}.tar"
             "http://pkgs.fedoraproject.org/repo/pkgs/microcode_ctl/amd-ucode-2012-09-10.tar/559bc355d3799538584add80df2996f0/${name}.tar"
           ];

    sha256 = "065phvhx5hx5ssdd1x2p5m1yv26ak7l5aaw6yk6h95x9mxn5r111";
  };

  installPhase = ''
    mkdir -p $out/amd-ucode
    mv microcode_amd_fam15h.bin microcode_amd.bin $out/amd-ucode/
  '';

  meta = {
    description = "AMD Processor Microcode Patch";
    homepage = "http://www.amd64.org/support/microcode.html";
    license = "non-free";
  };
}
