{ stdenv, libtorrent, openssl, openssl_1_1, fetchFromGitHub }:
let
  ps = fetchFromGitHub {
    rev = "37c9d4b45be2ab5f0b7ff9123c471fd517c22033";
    owner = "pyroscope";
    repo = "rtorrent-ps";
    sha256 = "1hl7mwndra30q3bcjprzqh2j9dirx6ym8mzamgydp1iywk0dqdwj";
  };
  libtorrent_0_13_6 = libtorrent.overrideAttrs (o: rec {
    name = "libtorrent-${version}";
    version = "0.13.6";
    src = fetchFromGitHub {
      owner = "rakshasa";
      repo = "libtorrent";
      rev = "${version}";
      sha256 = "1rvrxgb131snv9r6ksgzmd74rd9z7q46bhky0zazz7dwqqywffcp";
    };
  });
in
libtorrent_0_13_6.overrideAttrs (o: rec {
  version = "1.1-${builtins.substring 0 7 ps.rev}";
  name = "libtorrent-ps-${version}";
  buildInputs = (stdenv.lib.remove openssl o.buildInputs) ++ [ openssl_1_1 ];
  patches = (o.patches or []) ++ (map (x: "${ps}/patches/${x}") [
    "backport*_${o.version}_*.patch"
    "backport*_all_*.patch"
    "lt-base-cppunit-pkgconfig.patch" # 0.13.6
    "lt-open-ssl-1.1.patch"
    "lt-ps-*_${o.version}.patch"
    "lt-ps-*_all.patch"
  ]);
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/pyroscope/rtorrent-ps;
    description = "BitTorrent library written in C++ for use with rtorrent-ps";

    platforms = platforms.unix;
    maintainers = with maintainers; [ yorickvp ];
    license = licenses.gpl2Plus;
  };
})
