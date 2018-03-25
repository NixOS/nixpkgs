{ stdenv, lib, makeWrapper, dev_only_shellcheck ? null,
fetchFromGitHub,

fzf, coreutils, libxml2, libxslt, jing, findutils, gnugrep, gnused,
docbook5
}:
stdenv.mkDerivation rec {
  name = "xmloscopy-${version}";
  version = "v0.1.1";

  buildInputs = [
    makeWrapper
    dev_only_shellcheck
  ];

  spath = lib.makeBinPath [
    fzf
    coreutils
    libxml2
    libxslt
    jing
    findutils
    gnugrep
    gnused
  ];

  src = fetchFromGitHub {
    owner = "grahamc";
    repo = "xmloscopy";
    rev = version;
    sha256 = "01i9hr0hh87p4qxfqx4vhml2mpdqggq2326vy7nymm2d4xpa5i1i";
  };

  installPhase = ''
    sed -i "s/hard to say/${version}/" ./xmloscopy
    type -P shellcheck && shellcheck ./xmloscopy
    chmod +x ./xmloscopy
    patchShebangs ./xmloscopy
    mkdir -p $out/bin
    cp ./xmloscopy $out/bin/
    wrapProgram $out/bin/xmloscopy \
      --set RNG "${docbook5}/xml/rng/docbook/docbook.rng" \
      --set PATH "${spath}"
  '';

  meta = {
    description = "wtf is my docbook broken?";
    homepage = https://github.com/grahamc/xmloscopy;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
