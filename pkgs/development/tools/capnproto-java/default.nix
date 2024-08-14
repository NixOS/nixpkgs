{ lib, stdenv, fetchFromGitHub, capnproto, pkg-config }:

stdenv.mkDerivation rec {
  pname = "capnproto-java";
  version = "0.1.16";

  src = fetchFromGitHub {
    owner = "capnproto";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7uYtRHKsJvbE1b0HbNXGbRXpkUHHLjMDIWLlOUcQWDk=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ capnproto ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "Cap'n Proto codegen plugin for Java";
    mainProgram = "capnpc-java";
    longDescription = "Only includes compiler plugin, the Java runtime/library that the generated code will link to must be built separately with Maven.";
    homepage = "https://dwrensha.github.io/capnproto-java/index.html";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple solson ];
  };
}
