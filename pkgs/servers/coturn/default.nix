{ stdenv, fetchFromGitHub, fetchpatch, openssl, libevent }:

stdenv.mkDerivation rec {
  pname = "coturn";
  version = "4.5.1.3";

  src = fetchFromGitHub {
    owner = "coturn";
    repo = "coturn";
    rev = version;
    sha256 = "1801931k4qdvc7jvaqxvjyhbh1xsvjz0pjajf6xc222n4ggar1q5";
  };

  buildInputs = [ openssl libevent ];

  patches = [
    ./pure-configure.patch
    (fetchpatch {
      name = "CVE-2020-26262.patch";
      url = "https://github.com/coturn/coturn/commit/abfe1fd08d78baa0947d17dac0f7411c3d948e4d.patch";
      sha256 = "06e0b92043d6afcd96f2cf514c60d17987642f41403cfb17cc35f37c7c726ba4";
    })
  ];

  meta = with stdenv.lib; {
    homepage = "https://coturn.net/";
    license = with licenses; [ bsd3 ];
    description = "A TURN server";
    platforms = platforms.all;
    broken = stdenv.isDarwin; # 2018-10-21
    maintainers = [ maintainers.ralith ];
  };
}
