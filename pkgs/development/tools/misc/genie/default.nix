{ stdenv
, fetchFromGitHub
, CoreServices
, writeText
}:

stdenv.mkDerivation {
  pname = "genie";
  version = "1023";

    src = fetchFromGitHub {
      owner = "bkaradzic";
      repo = "GENie";
      rev = "2760390c8bdfc9105c614da145a6fabfb4f36676";
      sha256 = "1y1pipj1mihzhgavfmyz47nnq1zn4d4zhv0zf10m1qccg00zh541";
    };

    preConfigure = ''
      substituteInPlace build/gmake.darwin/genie.make --replace gcc cc
    '';

    installPhase = ''
      install -d $out/bin
    	cp bin/*/genie $out/bin
    '';

    buildInputs = stdenv.lib.optional stdenv.isDarwin CoreServices;

    setupHook = ./setup-hook.sh;

    meta = with stdenv.lib; {
      description = "Project generator tool";
      homepage = "https://github.com/bkaradzic/GENie";
      license = licenses.bsd3;
    };
}
