{ pkgs, stdenv, fetchFromGitHub }:
with stdenv;
mkDerivation {
  # notsodeep doesn't have version number
  # So I added last commit date instead
  pname = "notsodeep";
  version = "2019.5.29";
  src = fetchFromGitHub {
    owner = "farukuzun";
    repo = "notsodeep";
    rev = "470532243bff92fd8314f3693c4748604078b484";
    sha256 = "0rzxszvjcv86516cv79zxs65jvd464483y6xv9g6l0bhjvrdr9kv";
  };

  buildInputs = with pkgs; [ libnetfilter_queue libnfnetlink ];
  installPhase = ''
    mkdir -p $out/bin
    cp notsodeep $out/bin
  '';
  meta = with lib; {
    description = "Active DPI circumvention utility for Linux";
    homepage = "https://github.com/farukuzun/notsodeep";
    license = licenses.asl20;
    maintainers = [ maintainers.damhiya ];
    platforms = platforms.linux;
  };
}
