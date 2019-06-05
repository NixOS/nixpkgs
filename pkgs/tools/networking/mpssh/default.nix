{ stdenv, fetchFromGitHub, openssh }:

stdenv.mkDerivation rec {
  pname = "mpssh";
  version = "1.3.3";

  src = fetchFromGitHub {
    sha256 = "0iibzb9qrwf9wsmp2b8j76qw66ql8fw5jx02x82a22fsaznb5dng";
    rev = version;
    repo = pname;
    owner = "ndenev";
  };

  buildInputs = [ openssh ];

  postPatch = ''
    substituteInPlace Makefile --replace /usr/local $out
    substituteInPlace Makefile --replace "-o root" ""
    '';

  makeFlags = "CC=cc LD=cc BIN=$(out)/bin SSHPATH=${openssh}/bin/ssh SCPPATH=${openssh}/bin/scp";

  meta = {
    homepage = "https://github.com/ndenev/mpssh";
    description = "Mass Parallel SSH";
    license = stdenv.lib.licenses.bsd3;

    longDescription = ''
      mpssh is a parallel ssh tool. What it does is connecting to a number of hosts
      specified in the hosts file and execute the same command on all of them,
      showing a nicely formatted output with each line prepended with the hostname
      that produced the line. It is also possible to specify a script on the local filesystem
      that will be first scp copied to the remote host and then executed.
    '';

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.ktf ];
  };
}
