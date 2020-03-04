{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "elfinfo";
  version = "1.0.1";

  goPackagePath = "github.com/xyproto/elfinfo";
  src = fetchFromGitHub {
    rev = version;
    owner = "xyproto";
    repo = "elfinfo";
    sha256 = "1iahivc1jm9gv1dijykw2pryjdwb896bv42xmq9v6ax86rsnzqww";
  };

  meta = with stdenv.lib; {
    description = "Small utility for showing information about ELF files";
    homepage = https://elfinfo.roboticoverlords.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
