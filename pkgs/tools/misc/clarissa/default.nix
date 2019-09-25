{ stdenv, fetchFromGitLab, pkgs, libpcap, perl }:

stdenv.mkDerivation rec {

  version = "0.5";
  name = "clarissa-${version}";

  src = fetchFromGitLab {
    owner = "evils";
    repo = "clarissa";
    rev = "d98f5fce06cd165699a93c6d3189e49d8d2ecca0";
    sha256 = "1c74m2w7aicidgaxl6a1i79py4kh15dhqsppkvbxb67sd726xg4i";
  };

  buildInputs = with pkgs; [ libpcap perl ];

  doCheck = true;

# set the Makefile paths to the nix store directory we're making
  installFlags = [ "DESTDIR=$(out)" "SYSDINST=0" ];

  meta = with stdenv.lib; {
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
