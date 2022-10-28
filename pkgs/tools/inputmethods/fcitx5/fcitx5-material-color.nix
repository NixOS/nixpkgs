{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "fcitx5-material-color";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "hosxy";
    repo = "Fcitx5-Material-Color";
    rev = version;
    sha256 = "sha256-i9JHIJ+cHLTBZUNzj9Ujl3LIdkCllTWpO1Ta4OT1LTc=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 arrow.png radio.png -t $out/share/fcitx5-material-color/
    for _variant in black blue brown deepPurple indigo orange pink red sakuraPink teal; do
      _variant_name=Material-Color-$(echo $_variant | sed 's/\b[a-z]/\U&/g')
      install -dm755 $out/share/fcitx5/themes/$_variant_name/
      ln -s $out/share/fcitx5-material-color/arrow.png $out/share/fcitx5/themes/$_variant_name/
      ln -s $out/share/fcitx5-material-color/radio.png $out/share/fcitx5/themes/$_variant_name/
      install -Dm644 theme-$_variant.conf $out/share/fcitx5/themes/$_variant_name/theme.conf
      sed -i "s/^Name=.*/Name=$_variant_name/" $out/share/fcitx5/themes/$_variant_name/theme.conf
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Material color theme for fcitx5";
    homepage = "https://github.com/hosxy/Fcitx5-Material-Color";
    license = licenses.asl20;
    maintainers = with maintainers; [ candyc1oud ];
  };
}
