{ python3Packages, fetchurl, lib, pkgs }:

python3Packages.buildPythonPackage rec {
	pname = "mat2";
	version = "0.12.0";

	# TODO: Verify upstream's signature, to ensure maintainers get an authentic
	#  archive when importing a new version and setting its hash.
	# #43233 mentions adding support in Nix's tooling, but nothing seems to exist.
	srcs = fetchurl {
		url = "${meta.homepage}/-/archive/${version}/${pname}-${version}.tar.gz";
		sha256 = "185shmq35y2qj8ydy9l6v53flv536b8hrmv35b6ly22bczfs99yj";
	};

	propagatedBuildInputs =
		(with python3Packages; [
			mutagen
			pygobject3
		]) ++ (with pkgs; [
			bubblewrap
			cairo
			exiftool
			ffmpeg
			librsvg
			poppler_gi
			gdk_pixbuf
		]);

	# Test runner seems to have incorrect PATH
	doCheck = false;

	meta = with lib; {
		homepage = "https://0xacab.org/jvoisin/${pname}";
		description = "Metadata Anonymisation Toolkit — remove metadata from various media formats";

		license = licenses.lgpl3Plus;
		platforms = platforms.unix;
		maintainers = with maintainers; [ nicoo ];
	};
}
