{ buildGoModule
, fetchFromGitHub
, lib
, stdenv
}:
let
  pname = "nar-serve";
  version = "0.3.0";

in
buildGoModule rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "nar-serve";
    rev = "v${version}";
    sha256 = "000xxrar5ngrqqfi7ynx84i6wi27mirgm26brhyg0y4pygc9ykhz";
  };

  vendorSha256 = "0qkzbr85wkx3r7qgnzg9pdl7vsli10bzcdbj2gqd1kdzwb8khszs";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Serve NAR file contents via HTTP";
    homepage = "https://github.com/numtide/nar-serve";
    license = licenses.mit;
    maintainers = with maintainers; [ rizary ];
  };
}
