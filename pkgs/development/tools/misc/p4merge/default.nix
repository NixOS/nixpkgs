{ stdenv, fetchurl }:

let 
  version = "18.2";
  branch = "1661700";
in

stdenv.mkDerivation {

  name = "p4merge";

  src = fetchurl {
    url = "https://cdist2.perforce.com/perforce/r${version}/bin.linux26x86_64/p4v.tgz";
    sha256 = "18jxk9yf3480c0lgkpm53rkbblmjcv9qd21xilmp0jb9g2plmhfl";
  };

  installPhase = ''
    cp -r . $out
  '';

  meta = with stdenv.lib; {
    description = "Helix Visual Merge Tool (P4Merge) is a three-way merging and side-by-side file comparison tool.";
    homepage = https://www.perforce.com/downloads/visual-merge-tool;
    license = licenses.openssl;
    maintainers = [ maintainers.psyanticy ];
    platforms = platforms.linux;
  };
}

