{ stdenv, fetchFromGitHub, makeWrapper, perlPackages }:

let
  perlLibs = with perlPackages; [ NetDBus XMLTwig XMLParser ];
in
stdenv.mkDerivation {
  pname = "hsphfpd";
  version = "2020-11-27";

  src = fetchFromGitHub {
    owner = "pali";
    repo = "hsphfpd-prototype";
    rev = "58ffbf8f1b457e46801039d572cd344472828714";
    sha256 = "1hyg3cz6s58k6a7a3hcbs6wfk14cflnikd9psi7sirq6cn1z0ggb";
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

  meta = with stdenv.lib; {
    description = "Bluetooth HSP/HFP daemon";
    homepage = "https://github.com/pali/hsphfpd-prototype";
    license = licenses.artistic1;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.linux;
  };
}
