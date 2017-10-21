{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "earlyoom-${version}";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = "earlyoom";
    rev = "08b7ed8e72feed2eec2e558ba2cfacbf6d469594";
    sha256 = "1k3xslb70fzk80wlka32l0k2v45qn1xgwyjkjiz85gv6v4mv92vl";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp earlyoom $out/bin
  '';

  meta = {
    description = "Early OOM Daemon for Linux";
    homepage    = https://github.com/rfjakob/earlyoom;
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
