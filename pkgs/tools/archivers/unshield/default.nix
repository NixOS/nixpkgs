{ stdenv, fetchFromGitHub, fetchpatch, cmake, zlib, openssl }:

stdenv.mkDerivation rec {
  name = "unshield-${version}";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "twogood";
    repo = "unshield";
    rev = version;
    sha256 = "0cg84jr0ymvi8bmm3lx5hshhgm33vnr1rma1mfyqkc065c7gi9ja";
  };

  patches = [
    # Fix build in separate directory
    (fetchpatch {
      url = "https://github.com/twogood/unshield/commit/07ce8d82f0f60b9048265410fa8063298ab520c4.patch";
      sha256 = "160pbk2r98lv3vd0qxsxm6647qn5mddj37jzfmccdja4dpxhxz2z";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib openssl ];

  meta = with stdenv.lib; {
    description = "Tool and library to extract CAB files from InstallShield installers";
    homepage = https://github.com/twogood/unshield;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
