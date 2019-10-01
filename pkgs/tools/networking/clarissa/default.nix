{ stdenv, fetchFromGitLab, libpcap, perl }:

stdenv.mkDerivation rec {

  version = "0.6";
  name = "clarissa-${version}";

  src = fetchFromGitLab {
    owner = "evils";
    repo = "clarissa";
    rev = "v${version}";
    sha256 = "0xm9v9h4v7s2rdwzfjnmlfas18x9qirrcn01qvclca63pypz3xdk";
  };

  buildInputs = [ libpcap perl ];

  doCheck = true;

  installFlags = [ "DESTDIR=${placeholder "out"}" "PREFIX=" "SYSDINST=false" ];

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
    maintainers = [ maintainers.evils ];
  };
}
