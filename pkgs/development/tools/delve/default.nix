{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "delve-${version}";
  version = "0.12.2";

  goPackagePath = "github.com/derekparker/delve";
  excludedPackages = "\\(_fixtures\\|scripts\\|service/test\\)";

  src = fetchFromGitHub {
    owner = "derekparker";
    repo = "delve";
    rev = "v${version}";
    sha256 = "1241zqyimgqil4qd72f0yiw935lkdmfr88kvqbkn9n05k7xhdg30";
  };

  meta = {
    description = "debugger for the Go programming language";
    homepage = https://github.com/derekparker/delve;
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
