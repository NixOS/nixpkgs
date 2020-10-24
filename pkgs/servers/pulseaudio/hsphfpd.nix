{ stdenv, fetchFromGitHub, makeWrapper, perlPackages }:

let
  perlLibs = with perlPackages; [ NetDBus XMLTwig XMLParser ];
in
stdenv.mkDerivation {
  pname = "hsphfpd";
  version = "2020-10-25";

  src = fetchFromGitHub {
    owner = "pali";
    repo = "hsphfpd-prototype";
    rev = "601bf8f7bf2da97257aa6f786ec4cbb69b0ecbc8";
    sha256 = "06hh0xmp143334x8dg5nmp5727g38q2m5kqsvlrfia6vw2hcq0v0";
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
