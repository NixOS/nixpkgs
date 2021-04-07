{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gtk-mac-bundler";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "GNOME";
    repo = "gtk-mac-bundler";
    rev = "bundler-${version}";
    sha256 = "1kyyq2hc217i5vhbfff0ldgv0r3aziwryd1xlck5cw3s6hgskbza";
  };

  installPhase = ''
    mkdir -p $out/bin
    substitute gtk-mac-bundler.in $out/bin/gtk-mac-bundler \
      --subst-var-by PATH $out/share
    chmod a+x $out/bin/gtk-mac-bundler

    mkdir -p $out/share
    cp -r bundler $out/share
  '';

  meta = with lib; {
    description = "a helper script that creates application bundles form GTK executables for macOS";
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.darwin;
    homepage = "https://wiki.gnome.org/Projects/GTK/OSX/Bundling";
    license = licenses.gpl2;
  };
}
