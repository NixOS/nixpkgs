{ stdenv, fetchFromGitHub, fetchpatch, openssl, libevent }:

stdenv.mkDerivation rec {
  pname = "coturn";
  version = "4.5.1.1";

  src = fetchFromGitHub {
    owner = "coturn";
    repo = "coturn";
    rev = version;
    sha256 = "12x604lgva1d3g4wvl3f66rdj6lkjk5cqr0l3xas33xgzgm13pwr";
  };

  buildInputs = [ openssl libevent ];

  patches = [
    ./pure-configure.patch
    (fetchpatch {
      name = "CVE-2020-6061+6062.patch";
      url = "https://sources.debian.org/data/main/c/coturn/4.5.1.1-1.2/debian/patches/CVE-2020-6061+6062.patch";
      sha256 = "0fcy1wp91bb4hlhnp96sf9bs0d9hf3pwx5f7b1r9cfvr3l5c1bk2";
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
