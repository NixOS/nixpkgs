{ fetchFromGitHub, openttd, ... }:

openttd.overrideAttrs (oldAttrs: rec {
  pname = "openttd-jgrpp";
  version = "0.44.0";

  src = fetchFromGitHub rec {
    owner = "JGRennison";
    repo = "OpenTTD-patches";
    rev = "jgrpp-${version}";
    sha256 = "sha256-/kqwMZGXUYWlCnjk6uShJ5UARtvBSZWPExVel5o4xA8=";
  };
})
