{ stdenv, which, autoconf, automake, fetchFromGitHub,
  libtool, freeimage, mesa }:
stdenv.mkDerivation rec {
  version = "v1.0.2";
  name = "gamecube-tools-${version}";

  nativeBuildInputs = [ which autoconf automake libtool ];
  buildInputs = [ freeimage mesa ];

  src = fetchFromGitHub {
    owner = "devkitPro";
    repo  = "gamecube-tools";
    rev = version;
    sha256 = "0zvpkzqvl8iv4ndzhkjkmrzpampyzgb91spv0h2x2arl8zy4z7ca";
  };

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    description = "Tools for gamecube/wii projects";
    homepage = "https://github.com/devkitPro/gamecube-tools/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ tomsmeets ];
  };
}
