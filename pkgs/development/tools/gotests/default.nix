{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gotests-${version}";
  version = "1.5.3";
  rev = "v${version}";

  goPackagePath = "github.com/cweill/gotests";
  excludedPackages = "testdata";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    inherit rev;
    owner = "cweill";
    repo = "gotests";
    sha256 = "1c0hly31ax0wk01zdx0l0yl40xybaizjfb3gjxia2z0mgx330dq9";
  };

  meta = {
    description = "Generate Go tests from your source code.";
    homepage = https://github.com/cweill/gotests;
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.asl20;
  };
}
