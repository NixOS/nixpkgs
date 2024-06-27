{ stdenv, lib, python2, makeWrapper, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gtk-mac-bundler";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "GNOME";
    repo = "gtk-mac-bundler";
    rev = "bundler-${version}";
    sha256 = "1kyyq2hc217i5vhbfff0ldgv0r3aziwryd1xlck5cw3s6hgskbza";
  };

  buildInputs = [ python2 ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    substitute gtk-mac-bundler.in $out/bin/gtk-mac-bundler \
      --subst-var-by PATH $out/share
    chmod a+x $out/bin/gtk-mac-bundler
    wrapProgram $out/bin/gtk-mac-bundler \
      --set PATH ${lib.makeBinPath [
        python2
      ]}

    mkdir -p $out/share
    cp -r bundler $out/share
  '';

  meta = with lib; {
    description = "Helper script that creates application bundles from GTK executables for macOS";
    maintainers = [ maintainers.matthewbauer maintainers.iivusly ];
    platforms = platforms.darwin;
    homepage = "https://gitlab.gnome.org/GNOME/gtk-mac-bundler";
    license = licenses.gpl2;
  };
}
