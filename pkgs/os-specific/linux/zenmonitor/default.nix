{ stdenv, fetchFromGitHub, pkgconfig, gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "zenmonitor";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "ocerman";
    repo = "zenmonitor";
    rev = "v${version}";
    sha256 = "16p2njrgik8zfkidm64v4qy53qlsqqxxgr9m3n84pr9l3pk25dwk";
  };

  buildInputs = [ gtk3 ];
  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "Monitoring software for AMD Zen-based CPUs";
    homepage = https://github.com/ocerman/zenmonitor;
    license = licenses.mit;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ alexbakker ];
  };
}
