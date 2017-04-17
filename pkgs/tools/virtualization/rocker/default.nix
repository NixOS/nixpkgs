{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.3.0";
  name = "rocker-${version}";

  src = fetchurl {
    url = "https://github.com/grammarly/rocker/releases/download/${version}/rocker_linux_amd64.tar.gz";
    sha256 = "0jcxphkarzicxif2virdr7d7kym0961ca5l59cxmaqxa46l6k5x0";
  };

  outputs = [ "out" "bin" ];
  dontBuild = true;

  unpackPhase = ''
    tar xfz $src
  '';

  installPhase = ''
    mkdir -p {$bin,$out}
    mv rocker $bin/rocker
    chmod +x $bin/rocker
    ln -s $bin $out/bin

    interpreter="$(echo ${stdenv.glibc.out}/lib/ld-linux*)"
    patchelf --interpreter "$interpreter" "$bin/rocker"
  '';

  meta = with stdenv.lib; {
    description = "Rocker breaks the limits of Dockerfile";
    longDescription = ''
      Rocker breaks the limits of Dockerfile.
      It adds some crucial features that are missing while keeping Docker’s original design and idea.
    '';
    homepage = https://github.com/grammarly/rocker;
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.nequissimus ];
  };
}
