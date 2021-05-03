{ lib, stdenv, fetchFromGitHub, python2, xorg, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "disper";
  version = "0.3.1.1";

  src = fetchFromGitHub {
    owner = "apeyser";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1kl4py26n95q0690npy5mc95cv1cyfvh6kxn8rvk62gb8scwg9zn";
  };

  nativeBuildInputs = [ makeWrapper ];

  strictDeps = true;

  buildInputs = [ python2 ];

  preConfigure = ''
    export makeFlags="PREFIX=$out"
  '';

  postInstall = ''
      wrapProgram $out/bin/disper \
        --prefix "LD_LIBRARY_PATH" : "${lib.makeLibraryPath [ xorg.libXrandr xorg.libX11 ]}"
  '';

  meta = {
    description = "On-the-fly display switch utility";
    homepage = "https://willem.engen.nl/projects/disper/";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3;
  };

}
