{ stdenv, fetchgit, gtk-engine-murrine }:

stdenv.mkDerivation {
  name = "orion-1.5";

  src = fetchgit {
    url = "https://github.com/shimmerproject/Orion.git";
    rev = "refs/tags/v1.5";
    sha256 = "1116yawv3fspkiq1ykk2wj0gza3l04b5nhldy0bayzjaj0y6fd89";
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
    platforms = stdenv.lib.platforms.linux;
  };
}
