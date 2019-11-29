{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "elfinfo";
  version = "0.7.6";

  goPackagePath = "github.com/xyproto/elfinfo";
  src = fetchFromGitHub {
    rev = version;
    owner = "xyproto";
    repo = "elfinfo";
    sha256 = "0f6ik4d157assxdfslnyc91mg70kfh396rapikfv473znx2v2pg9";
  };

  meta = with stdenv.lib; {
    description = "Small utility for showing information about ELF files";
    homepage = https://elfinfo.roboticoverlords.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
