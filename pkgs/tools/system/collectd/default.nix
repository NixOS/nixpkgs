{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  darwin,
  callPackage,
  autoreconfHook,
  pkg-config,
  libtool,
  nixosTests,
  ...
}@args:
let
  plugins = callPackage ./plugins.nix args;
in
stdenv.mkDerivation rec {
  version = "5.12.0";
  pname = "collectd";

  src = fetchurl {
    url = "https://collectd.org/files/${pname}-${version}.tar.bz2";
    sha256 = "1mh97afgq6qgmpvpr84zngh58m0sl1b4wimqgvvk376188q09bjv";
  };

  patches = [
    # fix -t never printing syntax errors
    # should be included in next release
    (fetchpatch {
      url = "https://github.com/collectd/collectd/commit/3f575419e7ccb37a3b10ecc82adb2e83ff2826e1.patch";
      sha256 = "0jwjdlfl0dp7mlbwygp6h0rsbaqfbgfm5z07lr5l26z6hhng2h2y";
    })
    (fetchpatch {
      name = "no_include_longintrepr.patch";
      url = "https://github.com/collectd/collectd/commit/623e95394e0e62e7f9ced2104b786d21e9c0bf53.patch";
      hash = "sha256-0eD7yNW3TWVyNMpLsADhYFDvy6COoCaI0kS1XJrwDgM=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs =
    [
      libtool
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.ApplicationServices
    ]
    ++ plugins.buildInputs;

  configureFlags =
    [
      "--localstatedir=/var"
      "--disable-werror"
    ]
    ++ plugins.configureFlags
    ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ "--with-fp-layout=nothing" ];

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

  passthru.tests = {
    inherit (nixosTests) collectd;
  };

  meta = with lib; {
    description = "Daemon which collects system performance statistics periodically";
    homepage = "https://collectd.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
