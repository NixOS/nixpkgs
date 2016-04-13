{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "ratools-${version}";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "danrl";
    repo = "ratools";
    rev = "v${version}";
    sha256 = "07m45bn9lzgbfihmxic23wqp73nxg5ihrvkigr450jq6gzvgwawq";
  };

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  makeFlags = "-C src";

  installPhase = ''
    mkdir -p $out/{bin,sbin,share/man/man8}
    cp bin/ractl $out/bin
    cp bin/rad $out/sbin
    cp man/* $out/share/man/man8
  '';

  meta = with stdenv.lib; {
    description = "a fast, dynamic, multi-threading framework for IPv6 Router Advertisements";
    homepage = https://github.com/danrl/ratools;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.fpletz ];
  };
}
