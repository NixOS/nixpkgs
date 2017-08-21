{stdenv, fetchurl, libX11, imake, libXext, libXt}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}.${patchlevel}";
  pname = "xzoom";
  version = "0.3";
  patchlevel = "24";

  # or fetchFromGitHub(owner,repo,rev) or fetchgit(rev)
  src = fetchurl {
    url = "http://www.ibiblio.org/pub/linux/libs/X/${pname}-${version}.tgz";
    sha256 = "0jzl5py4ny4n4i58lxx2hdwq9zphqf7h3m14spl3079y5mlzssxj";
  };
  patches = [
    (fetchurl {
       url = "http://http.debian.net/debian/pool/main/x/xzoom/xzoom_${version}-${patchlevel}.diff.gz";
       sha256 = "0zhc06whbvaz987bzzzi2bz6h9jp6rv812qs7b71drivvd820qbh";
    })
  ];
  buildInputs = [libX11 imake libXext libXt];

  configurePhase = ''
    xmkmf
    makeFlags="$makeFlags PREFIX=$out BINDIR=$out/bin MANPATH=$out/share/man"
  '';

  meta = {
    inherit version;
    description = "An X11 screen zoom tool";
    license = stdenv.lib.licenses.free ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
