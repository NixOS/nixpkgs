
{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {

	pname = "idsk";
  version = "0.16";
  rev = "1846729ac3432aa8c2c0525be45cfff8a513e007";
  short_rev = "${builtins.substring 0 7 rev}";
	name = "${pname}-${version}-${short_rev}";

  meta = with stdenv.lib; {
    description = "manipulating cpc dsk images and files";
    homepage = https://github.com/cpcsdk/idsk ;
    license = "unknown";
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };

	src = fetchFromGitHub {
		owner = "cpcsdk";
		repo  = "${pname}";
		rev = "${rev}";
		sha256 = "0d891lvf2nc8bys8kyf69k54rf3jlwqrcczbff8xi0w4wsiy5ckv";
	};

	nativeBuildInputs = [ cmake ];

	installPhase = ''
		mkdir -p $out/bin
		cp iDSK $out/bin
	'';
}
