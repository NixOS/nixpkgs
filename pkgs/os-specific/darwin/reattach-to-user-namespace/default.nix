{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "reattach-to-user-namespace";
  version = "2.9";

  src = fetchFromGitHub {
    owner = "ChrisJohnsen";
    repo = "tmux-MacOSX-pasteboard";
    rev = "v${version}";
    sha256 = "1qgimh58hcx5f646gj2kpd36ayvrdkw616ad8cb3lcm11kg0ag79";
  };

  buildFlags =
    if stdenv.hostPlatform.system == "x86_64-darwin" then
      [ "ARCHES=x86_64" ]
    else if stdenv.hostPlatform.system == "aarch64-darwin" then
      [ "ARCHES=arm64" ]
    else
      throw "reattach-to-user-namespace isn't being built for ${stdenv.hostPlatform.system} yet.";

  installPhase = ''
    mkdir -p $out/bin
    cp reattach-to-user-namespace $out/bin/
  '';

  meta = with lib; {
    description = "A wrapper that provides access to the Mac OS X pasteboard service";
    license = licenses.bsd2;
    maintainers = with maintainers; [ lnl7 ];
    platforms = platforms.darwin;
  };
}
