{
  pkgs,
  lib,
  eggDerivation,
  fetchegg,
}:

let
  eggs = import ./eggs.nix { inherit eggDerivation fetchegg; };
in

eggDerivation rec {
  pname = "ugarit-manifest-maker";
  version = "0.1";
  name = "${pname}-${version}";

  src = fetchegg {
    inherit version;
    name = pname;
    sha256 = "1jv8lhn4s5a3qphqd3zfwl1py0m5cmqj1h55ys0935m5f422547q";
  };

  buildInputs = with eggs; [
    matchable
    srfi-37
    fnmatch
    miscmacros
    ugarit
    numbers
  ];

  meta = with lib; {
    homepage = "https://www.kitten-technologies.co.uk/project/ugarit-manifest-maker/";
    description = "A tool for generating import manifests for Ugarit";
    mainProgram = "ugarit-manifest-maker";
    license = licenses.bsd3;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.unix;
  };
}
