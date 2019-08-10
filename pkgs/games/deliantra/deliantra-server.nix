{ stdenv, lib, fetchurl, perlPackages,
  autoconf, perl, gperf, optipng, pngnq, rsync, imagemagick, blitz,
  pkg-config, glib, boost, makeWrapper }:

let
  perl-deps = with perlPackages; [
    AnyEvent AnyEventAIO AnyEventBDB AnyEventIRC
    CompressLZF commonsense Coro CoroEV
    Deliantra DigestSHA1 EV PodPOM SafeHole URI YAMLLibYAML
  ];
in
stdenv.mkDerivation rec {
  name = "deliantra-server-${version}";
  version = "3.1";

  src = fetchurl {
    url = "http://dist.schmorp.de/deliantra/deliantra-server-3.1.tar.xz";
    sha256 = "0v0m2m9fxq143aknh7jb3qj8bnpjrs3bpbbx07c18516y3izr71d";
  };

  nativeBuildInputs = [
    autoconf perl gperf optipng pngnq rsync imagemagick blitz
    pkg-config glib boost makeWrapper
  ];
  propagatedBuildInputs = perl-deps;

  hardeningDisable = [ "format" ];
  patches = [ ./0001-abs.patch ./0002-datadir.patch ];
  postFixup = ''
    wrapProgram $out/bin/cfutil --prefix PERL5LIB : $PERL5LIB
    wrapProgram $out/bin/deliantra-server --prefix PERL5LIB : $PERL5LIB
  '';

  meta = with lib; {
    description = "Server for the Deliantra free MMORPG";
    homepage = "http://www.deliantra.net/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
