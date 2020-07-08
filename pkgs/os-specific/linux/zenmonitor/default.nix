{ stdenv, fetchFromGitHub, pkgconfig, gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "zenmonitor";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "ocerman";
    repo = "zenmonitor";
    rev = "v${version}";
    sha256 = "1g6sk2mcd7znjq6zmbf2fgn02a0yimyv2dw2143aciq2pxqjawmp";
  };

  buildInputs = [ gtk3 ];
  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "Monitoring software for AMD Zen-based CPUs";
    homepage = "https://github.com/ocerman/zenmonitor";
    license = licenses.mit;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ alexbakker ];
  };
}
