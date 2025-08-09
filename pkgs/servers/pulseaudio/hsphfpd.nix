{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  perlPackages,
}:

let
  perlLibs = with perlPackages; [
    NetDBus
    XMLTwig
    XMLParser
  ];
in
stdenv.mkDerivation {
  pname = "hsphfpd";
  version = "2020-12-05";

  src = fetchFromGitHub {
    owner = "pali";
    repo = "hsphfpd-prototype";
    rev = "d294d064879591e9570ca3f444fa3eee2f269df8";
    sha256 = "0pm5rbsfrm04hnifzdmsyz17rjk8h9h6d19jaikjc5y36z03xf1c";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perlPackages.perl ];
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/dbus-1/system.d
    cp org.hsphfpd.conf $out/share/dbus-1/system.d

    mkdir -p $out/bin
    cp *.pl $out/bin

    runHook postInstall
  '';

  postFixup = ''
    for f in $out/bin/*.pl; do
      wrapProgram "$f" --set PERL5LIB "${perlPackages.makePerlPath perlLibs}"
    done
  '';

  meta = with lib; {
    description = "Bluetooth HSP/HFP daemon";
    homepage = "https://github.com/pali/hsphfpd-prototype";
    license = licenses.artistic1;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
