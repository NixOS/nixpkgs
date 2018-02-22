{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {

  repo = "idsk";
  version = "unstable-2018-02-11";
  rev = "1846729ac3432aa8c2c0525be45cfff8a513e007";
  name = "${repo}-${version}";

  meta = with stdenv.lib; {
    description = "Manipulating CPC dsk images and files";
    homepage = https://github.com/cpcsdk/idsk ;
    license = "unknown";
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };

  src = fetchFromGitHub {
    inherit rev repo;
    owner = "cpcsdk";
    sha256 = "0d891lvf2nc8bys8kyf69k54rf3jlwqrcczbff8xi0w4wsiy5ckv";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    mkdir -p $out/bin
    cp iDSK $out/bin
  '';
}
