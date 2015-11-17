{ stdenv, fetchFromGitHub, autoreconfHook }:

let version = "0.2.2"; in
stdenv.mkDerivation rec {
  name = "gpart-${version}";

  # GitHub repository 'collating patches for gpart from all distributions':
  src = fetchFromGitHub {
    sha256 = "09lp8m4241mxq7rlg70z66km7pq5bq48ydgkz55gakwqvnvd1mi3";
    rev = "v${version}";
    repo = "gpart";
    owner = "baruch";
  };

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    inherit version;
    inherit (src.meta) homepage;
    description = "Guess PC-type hard disk partitions";
    longDescription = ''
      Gpart is a tool which tries to guess the primary partition table of a
      PC-type hard disk in case the primary partition table in sector 0 is
      damaged, incorrect or deleted. The guessed table can be written to a file
      or device.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ nckx ];
  };
}
