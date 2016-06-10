{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gotty-${version}";
  version = "0.0.10";
  rev = "v${version}";

  goPackagePath = "github.com/yudai/gotty";

  src = fetchFromGitHub {
    inherit rev;
    owner = "yudai";
    repo = "gotty";
    sha256 = "0gvnbr61d5si06ik2j075jg00r9b94ryfgg06nqxkf10dp8lgi09";
  };

  goDeps = ./deps.json;

  meta = with stdenv.lib; {
    description = "Share your terminal as a web application";
    homepage = "https://github.com/yudai/gotty";
    maintainers = with maintainers; [ matthiasbeyer ];
    license = licenses.mit;
  };
}
