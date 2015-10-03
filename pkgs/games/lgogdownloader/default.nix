{ stdenv, fetchgit, curl, boost, jsoncpp, liboauth, rhash, tinyxml, htmlcxx, help2man }:

stdenv.mkDerivation rec {
  name = "lgogdownloader-${version}";
  version = "2.24";

  src = fetchgit {
    url = "https://github.com/Sude-/lgogdownloader.git";
    rev = "refs/tags/v${version}";
    sha256 = "1h5l4zc22hj4all2w0vfby1rmhpca33g3bhdnqw11w2ligk8j14r";
  };

  buildInputs = [ curl boost jsoncpp liboauth rhash tinyxml htmlcxx help2man ];

  buildPhase = ''
    make release
  '';

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = {
    homepage = https://github.com/Sude-/lgogdownloader;
    description = "Unofficial downloader to GOG.com for Linux users. It uses the same API as the official GOGDownloader.";
    license = stdenv.lib.licenses.wtfpl;
    platforms = stdenv.lib.platforms.linux;
  };
}
