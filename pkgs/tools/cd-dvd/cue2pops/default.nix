{ stdenv, fetchFromGitHub }:

with stdenv.lib;
stdenv.mkDerivation {
  pname = "cue2pops";
  version = "git-2018-01-04";

  src = fetchFromGitHub {
    owner = "makefu";
    repo = "cue2pops-linux";
    rev = "541863adf23fdecde92eba5899f8d58586ca4551";
    sha256 = "05w84726g3k33rz0wwb9v77g7xh4cnhy9sxlpilf775nli9bynrk";
  };

  dontConfigure = true;

  makeFlags = ["CC=cc"];

  installPhase = ''
    install --directory --mode=755 $out/bin
    install --mode=755 cue2pops $out/bin
  '';

  meta = {
    description = "Convert CUE to ISO suitable to POPStarter";
    homepage = https://github.com/makefu/cue2pops-linux;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.all;
  };
}
