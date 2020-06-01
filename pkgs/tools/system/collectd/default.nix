{ stdenv, fetchurl, fetchpatch, darwin, callPackage
, autoreconfHook
, pkgconfig
, libtool
, ...
}@args:
let
  plugins = callPackage ./plugins.nix args;
in
stdenv.mkDerivation rec {
  version = "5.11.0";
  pname = "collectd";

  src = fetchurl {
    url = "https://collectd.org/files/${pname}-${version}.tar.bz2";
    sha256 = "1cjxksxdqcqdccz1nbnc2fp6yy84qq361ynaq5q8bailds00mc9p";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [
    libtool
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.ApplicationServices
  ] ++ plugins.buildInputs;

  configureFlags = [
    "--localstatedir=/var"
    "--disable-werror"
  ] ++ plugins.configureFlags;

  # do not create directories in /var during installPhase
  postConfigure = ''
     substituteInPlace Makefile --replace '$(mkinstalldirs) $(DESTDIR)$(localstatedir)/' '#'
  '';

  postInstall = ''
    if [ -d $out/share/collectd/java ]; then
      mv $out/share/collectd/java $out/share/
    fi
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Daemon which collects system performance statistics periodically";
    homepage = "https://collectd.org";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor fpletz ];
  };
}
