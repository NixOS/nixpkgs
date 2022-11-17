{ lib, stdenv, fetchurl, autoconf, libtool, automake, scdoc, python3 }:

stdenv.mkDerivation rec {
  pname = "nostril";
  version = "0.1.2";

  src = fetchurl {
    url = "https://cdn.jb55.com/tarballs/nostril/nostril-${version}.tar.gz";
    sha256 = "5e2cfd7d3e71b7429ff556f248b962872aebf78f1b432fba696692b7ba3f7603";

    # sha2 hash should match
    # https://cdn.jb55.com/tarballs/nostril/SHA256SUMS.txt
  };

  nativeBuildInputs = [ autoconf automake libtool scdoc python3 ];

  makeFlags = [ "PREFIX=$(out)" ];

  preBuild = ''
    patchShebangs nostril-query
  '';

  meta = with lib; {
    homepage = "http://git.jb55.com/nostril";
    description = "A tool for creating nostr events";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ jb55 ];
  };
}
