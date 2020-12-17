{ stdenv, mkDerivation, fetchFromGitHub, cmake, fuse, readline, pkgconfig, qtbase, qttools }:

mkDerivation rec {
  pname = "android-file-transfer";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "whoozle";
    repo = "android-file-transfer-linux";
    rev = "v${version}";
    sha256 = "0xmnwxr649wdzsa1vf3spl387hxs4pq0rldyrsr9hz43da4v081k";
  };

  nativeBuildInputs = [ cmake readline pkgconfig ];
  buildInputs = [ fuse qtbase qttools ];

  meta = with stdenv.lib; {
    description = "Reliable MTP client with minimalistic UI";
    homepage = "https://whoozle.github.io/android-file-transfer-linux/";
    license = licenses.lgpl21;
    maintainers = [ maintainers.xaverdh ];
    platforms = platforms.linux;
  };
}
