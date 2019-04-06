{ stdenv, fetchFromGitHub, buildGoModule }:

let
  owner = "gobuffalo";
  pname = "packr";
  version = "2.1.0";
in
buildGoModule rec {
  inherit pname version;

  src = fetchFromGitHub {
    inherit owner;
    repo = pname;
    rev = "v${version}";
    sha256 = "0i95hqwc2r7h8f2d9jyriryrlwb4s93mbr84r1a76dg7y1phadll";
  };

  sourceRoot = "source/v2";
  modSha256 = "11dpcms3pjcfsy40f1l5hhva3qanc3h4s9wkwmwgp2r79i7f1gyj";

  # Requires a valid GOROOT at runtime, and silently fails without
  # one.
  allowGoReference = true;

  modAttrs = {
    # `go mod download` consistently misses this one
    postBuild = ''
      go mod download 'github.com/spf13/pflag@v1.0.3'
    '';
  };

  meta = with stdenv.lib; {
    description = ''
      The simple and easy way to embed static files into Go binaries.
    '';
    platforms = platforms.unix;
    license = licenses.mit;
    homepage = https://github.com/gobuffalo/packr;
  };
}
