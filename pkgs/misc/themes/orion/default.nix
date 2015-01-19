{ stdenv, fetchgit, gtk-engine-murrine }:

stdenv.mkDerivation {
  name = "orion-1.5";

  src = fetchgit {
    url = "https://github.com/shimmerproject/Orion.git";
    rev = "refs/tags/v1.5";
    sha256 = "995671990514a68192dc82ed51eaa6ab17c396950e1d8b7768c262027be6b05f";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  phases = "$prePhases unpackPhase installPhase fixupPhase $postPhases";
  installPhase = ''
    mkdir -p $out/share/themes/orion
    cp -r gtk-2.0 gtk-3.0 metacity-1 openbox-3 xfwm4 $out/share/themes/orion
  '';

  meta = {
    homepage = https://github.com/shimmerproject/Orion;
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
