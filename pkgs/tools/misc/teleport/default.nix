{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "teleport-v${version}";
  version = "2.4.0";

  src = fetchurl {
    url = "https://github.com/gravitational/teleport/releases/download/v${version}/${name}-linux-amd64-bin.tar.gz";
    sha256 = "ab00de7d7f09a0768ebf40fe075ebfaa81891ae0238abc30bc5662fe25d881e9";
  };
  sourceRoot = ".";
  unpackCmd = ''
    tar -zxf $src teleport/{tctl,teleport,tsh}
  '';

  buildPhase = ":";   # nothing to build

  installPhase = ''
    mkdir -p $out/bin
    cp -R teleport/* $out/bin
  '';
  preFixup = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/bin/*
  '';

  meta = with stdenv.lib; {
    homepage = https://gravitational.com/teleport/;
    description = "Modern SSH server for clusters and teams";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.kimburgess ];
  };
}
