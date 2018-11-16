{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "delve-${version}";
  version = "1.1.0";

  goPackagePath = "github.com/derekparker/delve";
  excludedPackages = "\\(_fixtures\\|scripts\\|service/test\\)";

  src = fetchFromGitHub {
    owner = "derekparker";
    repo = "delve";
    rev = "v${version}";
    sha256 = "0gpsd9hb7r65rn4ml9jzsmy72b8j0id6wik2l48ghzkwjm72rsdz";
  };

  meta = with stdenv.lib; {
    description = "debugger for the Go programming language";
    homepage = https://github.com/derekparker/delve;
    maintainers = with maintainers; [ vdemeester ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ] ++ platforms.darwin;
  };
}
