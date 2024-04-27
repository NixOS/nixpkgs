{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "reftools";
  version = "unstable-2021-02-13";

  src = fetchFromGitHub {
    owner = "davidrjenni";
    repo = "reftools";
    rev = "40322ffdc2e46fd7920d1f8250051bbd2f3bd34d";
    sha256 = "sha256-fHWtUoVK3G0Kn69O6/D0blM6Q/u4LuLinT6sxF18nFo=";
  };

  vendorHash = null;

  doCheck = false;

  excludedPackages = "cmd/fillswitch/test-fixtures";

  meta = with lib; {
    description = "Refactoring tools for Go";
    homepage = "https://github.com/davidrjenni/reftools";
    license = licenses.bsd2;
    maintainers = with maintainers; [ kalbasit ];
  };
}
