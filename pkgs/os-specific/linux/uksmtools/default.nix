{ stdenv, fetchgit, cmake }:

stdenv.mkDerivation rec {
  name = "uksmtools-${version}";
  version = "2015-09-25";

  # This project uses git submodules, which fetchFromGitHub doesn't support:
  src = fetchgit {
    sha256 = "1nj53f24qjp0d87fzrz0y72rmv6lhxyiaqrsbd9v423h5zpmkrnj";
    rev = "9f59a3a0b494b758aa91d7d8fa04e21b5e6463c0";
    url = "https://github.com/pfactum/uksmtools.git";
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Tools to control Linux UKSM (Ultra Kernel Same-page Merging)";
    homepage = https://github.com/pfactum/uksmtools/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
