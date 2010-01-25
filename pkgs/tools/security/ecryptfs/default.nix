{stdenv, fetchurl, fuse, python, perl, keyutils, pam, nss, nspr}:
stdenv.mkDerivation {
  name = "ecryptfs-82";

  src = fetchurl {
    url = http://launchpad.net/ecryptfs/trunk/82/+download/ecryptfs-utils_82.orig.tar.gz;
    sha256 = "1w3swispgp71prz8h56hqby2wwnvam5vllqvc69rn8cf605i69a6";
  };

  NIX_CFLAGS_COMPILE = "-I${nspr}/include/nspr -I${nss}/include/nss";

  buildInputs = [ python perl keyutils pam nss nspr ];

  meta = {
    description = "Enterprise-class stacked cryptographic filesystem";
    license = "GPLv2+";
  };
}
