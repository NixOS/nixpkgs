{stdenv, composableDerivation, fetchurl, transfig, texLive}:

let
  version = "6.3";
  name = "ragel-${version}";
in

composableDerivation.composableDerivation {} {
  inherit name;
  src = fetchurl {
    url = "http://www.complang.org/ragel/${name}.tar.gz";
    sha256 = "018cedc8a68be85cda330fc53d0bb8a1ca6ad39b1cf790eed0311e7baa5a2520";
  };

  flags = {
    doc = {
      # require fig2dev & pdflatex (see README)
      buildInputs = [transfig texLive];
      # use post* because default values of buildPhase is empty.
      postBuild = ''
        pushd doc
        make
        popd
      '';
      postInstall = ''
        pushd doc
        make install
        popd
      '';
    };
  };

  cfg = {
    docSupport = false;
  };

  meta = {
    homepage = http://www.complang.org/ragel;
    description = "State machine compiler";
    license = stdenv.lib.licenses.gpl2;
  };
}
