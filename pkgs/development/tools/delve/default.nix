{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "delve-${version}";
  version = "1.0.0";

  goPackagePath = "github.com/derekparker/delve";
  excludedPackages = "\\(_fixtures\\|scripts\\|service/test\\)";

  src = fetchFromGitHub {
    owner = "derekparker";
    repo = "delve";
    rev = "v${version}";
    sha256 = "08hsairhrifh41d288jhc65zbhs9k0hs738dbdzsbcvlmycrhvgx";
  };

  meta = with stdenv.lib; {
    description = "debugger for the Go programming language";
    homepage = https://github.com/derekparker/delve;
    maintainers = with maintainers; [ vdemeester ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ] ++ platforms.darwin;
  };
}
