{ lib, stdenv, fetchFromGitHub, fetchpatch, capnproto, pkg-config }:

stdenv.mkDerivation rec {
  pname = "capnproto-java";
<<<<<<< HEAD
  version = "0.1.15";
=======
  version = "0.1.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "capnproto";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256:IcmzI1G0mXOlpzmiyeLD7o1p/eOeVpwkiGsgy5OIjxw=";
  };

=======
    hash = "sha256:1512x70xa6mlg9dmr84r8xbf0jzysjal51ivhhh2ppl97yiqjgls";
  };

  patches = [
    # Add make install rule
    (fetchpatch {
      url = "https://github.com/capnproto/capnproto-java/commit/e96448d3f5737db25e55cd268652712b69db5cc0.diff";
      sha256 = "0f3vyap1zsxy675900pzg5ngh7bf9icllm1w04q64g8i91sdzljl";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ capnproto ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "Cap'n Proto codegen plugin for Java";
    longDescription = "Only includes compiler plugin, the Java runtime/library that the generated code will link to must be built separately with Maven.";
    homepage = "https://dwrensha.github.io/capnproto-java/index.html";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ bhipple solson ];
=======
    maintainers = with maintainers; [ bhipple ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
