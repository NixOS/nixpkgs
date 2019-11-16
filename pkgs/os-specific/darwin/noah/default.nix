{ stdenv, fetchFromGitHub, cmake, Hypervisor }:

stdenv.mkDerivation rec {
  pname = "noah";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "linux-noah";
    repo = pname;
    rev = version;
    sha256 = "0bivfsgb56kndz61lzjgdcnqlhjikqw89ma0h6f6radyvfzy0vis";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ Hypervisor ];

  meta = with stdenv.lib; {
    description = "Bash on Ubuntu on macOS";
    homepage = "https://github.com/linux-noah/noah";
    license = [ licenses.mit licenses.gpl2 ];
    maintainers = [ maintainers.marsam ];
    platforms = platforms.darwin;
  };
}
