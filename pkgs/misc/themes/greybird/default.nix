{ stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "Greybird";
  version = "2016-03-11";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    repo = "${pname}";
    owner = "shimmerproject";
    rev = "77f3cbd94b0c87f502aaeeaa7fd6347283c876cf";
    sha256 = "1gqq9j61izdw8arly8kzr629wa904rn6mq48cvlaksknimw0hf2h";
  };

  buildInputs = [ gtk-engine-murrine ];
  
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/themes/${pname}{," Bright"," Compact"," a11y"}
    cp -a * $out/share/themes/${pname}/
    mv $out/share/themes/${pname}/xfce-notify-4.0_bright $out/share/themes/${pname}" Bright"/xfce-notify-4.0
    mv $out/share/themes/${pname}/xfwm4-compact $out/share/themes/${pname}" Compact"/xfwm4
    mv $out/share/themes/${pname}/xfwm4-a11y $out/share/themes/${pname}" a11y"/xfwm4
  '';

  meta = {
    description = "Grey and blue theme (Gtk, Xfce, Emerald, Metacity, Mutter, Unity)";
    homepage = http://shimmerproject.org/our-projects/greybird/;
    license = with stdenv.lib.licenses; [ gpl2Plus cc-by-nc-sa-30 ];
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
