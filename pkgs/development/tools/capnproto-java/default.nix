{ lib, stdenv, fetchFromGitHub, fetchpatch, capnproto, pkg-config }:

stdenv.mkDerivation rec {
  pname = "capnproto-java";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "capnproto";
    repo = pname;
    rev = "v${version}";
    hash = "sha256:IcmzI1G0mXOlpzmiyeLD7o1p/eOeVpwkiGsgy5OIjxw=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ capnproto ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "Cap'n Proto codegen plugin for Java";
    longDescription = "Only includes compiler plugin, the Java runtime/library that the generated code will link to must be built separately with Maven.";
    homepage = "https://dwrensha.github.io/capnproto-java/index.html";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple solson ];
  };
}
