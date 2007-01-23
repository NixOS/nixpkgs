{stdenv, fetchurl}:
   
stdenv.mkDerivation {
  name = "libnscd-2.0.2";
   
  src = fetchurl {
    url = http://suse.osuosl.org/people/kukuk/libnscd/libnscd-2.0.2.tar.bz2;
    sha256 = "0nxhwy42x44jlpdb5xq1prbvfjmds4hplmwv3687z0c4r9rn506l";
  };
}
