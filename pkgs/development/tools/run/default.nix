{ stdenv, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "run";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "TekWizely";
    repo = "run";
    rev = "v${version}";
    sha256 = "0365nvsqrlagrp08sifbdk3rgy7r4hmp3sx5zhizamadfcj2fsv6";
  };

  modSha256 = "0s2lw9q5jskj41jqr8bv5w45pkrp2s0yfd2hgjgsd0q4ifm07k7s";

  meta = with stdenv.lib; {
    description = "Easily manage and invoke small scripts and wrappers";
    homepage    = https://github.com/TekWizely/run;
    license     = licenses.mit;
    maintainers = with maintainers; [ rawkode ];
    platforms   = platforms.unix;
  };
}
