{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "elfinfo-${version}";
  version = "0.7.5";

  goPackagePath = "github.com/xyproto/elfinfo";
  src = fetchFromGitHub {
    rev = version;
    owner = "xyproto";
    repo = "elfinfo";
    sha256 = "0b6zyfq0yhpbf03h52q2lgf6ff086gcsbnhm6chx18h0q1g17m96";
  };

  meta = with stdenv.lib; {
    description = "Small utility for showing information about ELF files";
    homepage = https://elfinfo.roboticoverlords.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
