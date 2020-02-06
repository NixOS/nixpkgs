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
  version = "5.8.1";
  pname = "collectd";

  src = fetchurl {
    url = "https://collectd.org/files/${pname}-${version}.tar.bz2";
    sha256 = "1njk8hh56gb755xafsh7ahmqr9k2d4lam4ddj7s7fqz0gjigv5p7";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/rpv-tomsk/collectd/commit/d5a3c020d33cc33ee8049f54c7b4dffcd123bf83.patch";
      sha256 = "1n65zw4d2k2bxapayaaw51ym7hy72a0cwi2abd8jgxcw3d0m5g15";
    })
  ];

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
    homepage = https://collectd.org;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor fpletz ];
  };
}
