{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "elfinfo-${version}";
  version = "0.7.4";

  goPackagePath = "github.com/xyproto/elfinfo";
  src = fetchFromGitHub {
    rev = version;
    owner = "xyproto";
    repo = "elfinfo";
    sha256 = "12n86psri9077v7s6b4j7djg5kijf9gybd80f9sfs0xmgkbly3gv";
  };

  meta = with stdenv.lib; {
    description = "Small utility for showing information about ELF files";
    homepage = https://elfinfo.roboticoverlords.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
