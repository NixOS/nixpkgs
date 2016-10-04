{ stdenv, fetchurl, autoconf }:

stdenv.mkDerivation rec {
  version = "1.99";
  name = "dd_rescue-${version}";

  src = fetchurl {
    sha256 = "0gkbwssn134fjyyvjvylyvassw4fwv5mbis9gcb969xdc64dfhg1";
    url="http://www.garloff.de/kurt/linux/ddrescue/${name}.tar.bz2";
  };

  dd_rhelp_src = fetchurl {
    url = "http://www.kalysto.org/pkg/dd_rhelp-0.3.0.tar.gz";
    sha256 = "0br6fs23ybmic3i5s1w4k4l8c2ph85ax94gfp2lzjpxbvl73cz1g";
  };

  buildInputs = [ autoconf ];

  preBuild = ''
    substituteInPlace Makefile \
      --replace "\$(DESTDIR)/usr" "$out" \
      --replace "-o root" "" \
      --replace "-g root" "" 
  '';
  makeFlags = [ "LIBDIR=$out" ];

  postInstall = ''
    mkdir -p "$out/share/dd_rescue" "$out/bin"
    tar xf "${dd_rhelp_src}" -C "$out/share/dd_rescue"
    cp "$out/share/dd_rescue"/dd_rhelp*/dd_rhelp "$out/bin"
  '';
      
  meta = with stdenv.lib; {
    description = "A tool to copy data from a damaged block device";
    maintainers = with maintainers; [ raskin domenkozar ];
    platforms = platforms.linux;
    downloadPage = "http://www.garloff.de/kurt/linux/ddrescue/";
    inherit version;
    updateWalker = true;
  };
}
