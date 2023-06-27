{ stdenv, lib, fetchFromGitHub,bash }:
stdenv.mkDerivation rec {
  name = "maxfetch-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "jobcmax";
    repo = "maxfetch";
    rev = "574ba113e7cb6e99168f9aa43ef0e124607299dc";
    sha256 = "sha256-gdKVoeT6PhB/j5X//ZbcIrAfUoP4LeZKF2LEK+6J8wk=";
  };

  nativeBuildInputs = [ ];
  buildInputs = [ bash ];

  buildPhase = ''
    chmod +x maxfetch
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp maxfetch $out/bin
  '';
}
