{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "delve-${version}";
  version = "0.12.1";

  goPackagePath = "github.com/derekparker/delve";
  excludedPackages = "\\(_fixtures\\|scripts\\|service/test\\)";

  src = fetchFromGitHub {
    owner = "derekparker";
    repo = "delve";
    rev = "v${version}";
    sha256 = "0vkyx9sd66yrqz9sa4pysmpjv6gdgpfk1icrbjk93h2ry15ma8d6";
  };

  meta = {
    description = "debugger for the Go programming language";
    homepage = https://github.com/derekparker/delve;
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
