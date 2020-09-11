{ fetchFromGitHub, openttd, ... }:

openttd.overrideAttrs (oldAttrs: rec {
  pname = "openttd-jgrpp";
  version = "0.34.4";

  src = fetchFromGitHub rec {
    owner = "JGRennison";
    repo = "OpenTTD-patches";
    rev = "jgrpp-${version}";
    sha256 = "125mgia5hgcsn8314xyiip3z8y23rc3kdv7jczbncqlzsc75624v";
  };
})
