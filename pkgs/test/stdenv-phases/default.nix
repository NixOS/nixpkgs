{ stdenv
, makePhase


}:

let
  hook = makePhase {
    name = "myphase";
    function = ''
      export myphase_done=1
    '';
  };

in stdenv.mkDerivation {
  name = "test-addPhase";

  nativeBuildInputs = [
    hook
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir $out
  '';

  passthru = {
    inherit hook;
  };

}
