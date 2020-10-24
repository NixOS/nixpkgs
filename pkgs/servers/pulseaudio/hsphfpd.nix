{ stdenv, fetchFromGitHub
, makeWrapper, perlPackages }:

let
  perlLibs = with perlPackages; [ NetDBus XMLTwig XMLParser ];
in
stdenv.mkDerivation {
  pname = "hsphfpd";
  version = "2020-10-08";

  src = fetchFromGitHub {
    owner = "pali";
    repo = "hsphfpd-prototype";
    rev = "e254c6afb531ca77b3b76b89c6ffe58a6c6a8681";
    sha256 = "10a0rcdym0s614v8i39pfwsmm6a4qw123x308yzfi4p09skjwhgi";
  };

  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ perlPackages.perl ] ++ perlLibs;
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
}
