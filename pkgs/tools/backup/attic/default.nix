{ stdenv, fetchFromGitHub, python3Packages, openssl, acl }:

python3Packages.buildPythonPackage rec {
  version = "0.14";
  name = "attic-${version}";

  src = fetchFromGitHub {
    owner = "jborg";
    repo = "attic";
    rev = version;
    sha256 = "1ij99dmd571rvk3kz97vs7wbjj2pbbd54l310lydnwywxhqs8hrv";
  };

  propagatedBuildInputs = with python3Packages;
    [ cython msgpack openssl acl llfuse ];

  preConfigure = ''
    export ATTIC_OPENSSL_PREFIX="${openssl}"
  '';

  meta = with stdenv.lib; {
    description = "A deduplication backup program";
    homepage = "https://attic-backup.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.wscott ];
    platforms = platforms.unix; # Darwin and FreeBSD mentioned on homepage
  };
}
