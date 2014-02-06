{ stdenv, fetchurl, patchelf }:

stdenv.mkDerivation rec {
  name = "newrelic-sysmond-1.3.1.437";
  meta = {
    description = "New Relic system monitor daemon";
    homepage    = "https://newrelic.com";
    license     = stdenv.lib.licenses.unfree;
  };
  src = fetchurl {
    url    = "http://download.newrelic.com/server_monitor/release/${name}-linux.tar.gz";
    sha256 = "efe04ef6f1b23d327fe7bb56f4d181d6c42fec9d9cb8238d220defc5ef08b20f";
  };

  arch = if stdenv.system == "x86_64-linux" then "x64"
    else if stdenv.system == "i686-linux" then "x86"
    else throw "nrsysmond: ${stdenv.system} not supported!";
  daemonexe = "${name}-linux/daemon/nrsysmond." + arch;

  libPath = stdenv.lib.makeLibraryPath [ stdenv.gcc.libc ];
  buildInputs = [ patchelf ];

  unpackPhase = ''tar zxf $src'';

  installPhase = ''
    mkdir -p $out/bin
    cp ${daemonexe} $out/bin/nrsysmond
  '';

  fixupPhase = ''
    patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      --set-rpath $libPath $out/bin/nrsysmond
  '';

  phases = "unpackPhase installPhase fixupPhase";
}
