{ stdenv, fetchFromGitLab, pkgs, libpcap, perl }:

stdenv.mkDerivation rec
{
	version = "0.5-nix";
	name = "clarissa-${version}";

	src = fetchFromGitLab {
		owner = "evils";
		repo = "clarissa";
		rev = "09362630bd9745d24e774091ef26471c89cc6e1c";
		sha256 = "1w22vsqbcqw99nj799l251k3g828c1yh8skn1b7vaybv5qd8q8a5";
	};

	buildInputs = with pkgs; [ libpcap perl ];

	doCheck = true;

# set the Makefile paths to the nix store directory we're making
	installFlags = [ "DESTDIR=$(out)" "SYSDINST=0" ];

	meta = with stdenv.lib;
	{
		description = "Near real-time network census daemon";
		longDescription = ''
			Clarissa is a daemon which keeps track of connected MAC addresses on a network.
			It can report these with sub-second resolution and can monitor passively.
			Currently includes a utility to report a count of known and unknown addresses.
		'';
		homepage = https://gitlab.com/evils/clarissa/;
		license = licenses.bsd3;
		platforms = platforms.linux;
	};
}
