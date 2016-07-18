{stdenv, fetchurl, python, xorg, makeWrapper}:

stdenv.mkDerivation rec {
  name = "disper-0.3.1";

  buildInputs = [python makeWrapper];

  preConfigure = ''
    export makeFlags="PREFIX=$out"
  '';

  postInstall = ''
      wrapProgram $out/bin/disper \
        --prefix "LD_LIBRARY_PATH" : "${xorg.libXrandr.out}/lib:${xorg.libX11.out}/lib"
  '';

  src = fetchurl {
    url = http://ppa.launchpad.net/disper-dev/ppa/ubuntu/pool/main/d/disper/disper_0.3.1.tar.gz;
    sha256 = "1l8brcpfn4iascb454ym0wrv5kqyz4f0h8k6db54nc3zhfwy7vvw";
  };

  meta = {
    description = "On-the-fly display switch utility";
    homepage = http://willem.engen.nl/projects/disper/;
  };

}
