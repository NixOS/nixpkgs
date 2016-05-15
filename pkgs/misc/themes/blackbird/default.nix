{ stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "Blackbird";
  version = "2016-04-10";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    repo = "${pname}";
    owner = "shimmerproject";
    rev = "e9f780993c957e3349f97b0e2e6fabdc36ccefb0";
    sha256 = "00fdd63lnb2gmsn6cbdkanvh3rvz48jg08gmzg372byhj70m63hi";
  };

  buildInputs = [ gtk-engine-murrine ];
  
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/themes/${pname}
    cp -a * $out/share/themes/${pname}/
  '';

  meta = {
    description = "Dark Desktop Suite for Gtk, Xfce and Metacity";
    homepage = http://github.com/shimmerproject/Blackbird;
    license = with stdenv.lib.licenses; [ gpl2Plus cc-by-nc-sa-30 ];
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
