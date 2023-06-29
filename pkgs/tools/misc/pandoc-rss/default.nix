{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "pandoc-rss";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "chambln";
    repo = pname;
    rev = version;
    sha256 = "sha256-G2ALbpdrRuQeDtwczEXprq8kMtH/+gCboynqpsaySI8=";
  };

  doBuild = false;
  makeFlags = [ "PREFIX=${placeholder "out"}" ];
}
