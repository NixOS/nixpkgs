{ lib, stdenv, fetchFromGitHub, fetchurl, buildPackages
, libiconv, nkf, perl, which
, skk-dicts
}:

let
  iconvBin = if stdenv.isDarwin then libiconv else  buildPackages.stdenv.cc.libc;
in
stdenv.mkDerivation {
  pname = "cmigemo";
  version = "1.3e";

  src = fetchFromGitHub {
    owner = "koron";
    repo = "cmigemo";
    rev = "5c014a885972c77e67d0d17d367d05017c5873f7";
    sha256 = "0xrblwhaf70m0knkd5584iahaq84rlk0926bhdsrzmakpw77hils";
  };

  nativeBuildInputs = [ libiconv nkf perl which ];

  postUnpack = ''
    cp ${skk-dicts}/share/SKK-JISYO.L source/dict/
  '';

  patches = [ ./no-http-tool-check.patch ];

  makeFlags = [ "INSTALL=install" ];

  preBuild = ''
    makeFlagsArray+=(FILTER_UTF8="${lib.getBin iconvBin}/bin/iconv -t utf-8 -f cp932")
  '';

  buildFlags = [ (if stdenv.isDarwin then "osx-all" else "gcc-all") ];

  installTargets = [ (if stdenv.isDarwin then "osx-install" else "gcc-install") ];

  meta = with lib; {
    description = "A tool that supports Japanese incremental search with Romaji";
    homepage = "https://www.kaoriya.net/software/cmigemo";
    license = licenses.mit;
    maintainers = [ maintainers.cohei ];
    platforms = platforms.all;
  };
}
