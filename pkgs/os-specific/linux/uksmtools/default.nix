{ stdenv, fetchgit, cmake }:

let version = "2015-09-25"; in
stdenv.mkDerivation {
  name = "uksmtools-${version}";

  # This project uses git submodules, which fetchFromGitHub doesn't support:
  src = fetchgit {
    sha256 = "0ngdmici2vgi2z02brzc3f78j1g1y9myzfxn46zlm1skg94fp692";
    rev = "9f59a3a0b494b758aa91d7d8fa04e21b5e6463c0";
    url = "https://github.com/pfactum/uksmtools.git";
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  doCheck = false;

  meta = with stdenv.lib; {
    inherit version;
    description = "Tools to control Linux UKSM (Ultra Kernel Same-page Merging)";
    homepage = https://github.com/pfactum/uksmtools/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
