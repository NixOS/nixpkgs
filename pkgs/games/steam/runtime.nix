{ stdenv, fetchurl }:

let arch = if stdenv.system == "x86_64-linux" then "amd64"
           else if stdenv.system == "i686-linux" then "i386"
           else abort "Unsupported platform";

in stdenv.mkDerivation rec {
  name = "steam-runtime-${version}";
  version = "2014-04-15";

  phases = [ "unpackPhase" "installPhase" ];

  src = fetchurl {
    url = "http://media.steampowered.com/client/runtime/steam-runtime-release_${version}.tar.xz";
    sha256 = "0i6xp81rjbfn4664h4mmvw0xjwlwvdp6k7cc53jfjadcblw5cf99";
  };

  installPhase = ''
    mkdir -p $out
    mv ${arch}/* $out/
  '';

  passthru = rec {
    inherit arch;

    gnuArch = if arch == "amd64" then "x86_64-linux-gnu"
              else if arch == "i386" then "i386-linux-gnu"
              else abort "Unsupported architecture";

    libs = [ "lib/${gnuArch}" "lib" "usr/lib/${gnuArch}" "usr/lib" ];
    bins = [ "bin" "usr/bin" ];
  };

  meta = with stdenv.lib; {
    description = "The official runtime used by Steam";
    homepage = https://github.com/ValveSoftware/steam-runtime;
    license = licenses.mit;
    maintainers = with maintainers; [ hrdinka ];
    hydraPlatforms = [];
  };
}
