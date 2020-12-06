{ stdenv, system, fetchurl }:

let
  linuxPredicate = system == "x86_64-linux";
  bsdPredicate = system == "x86_64-freebsd";
  darwinPredicate = system == "x86_64-darwin";
  metadata = assert linuxPredicate || bsdPredicate || darwinPredicate;
    if linuxPredicate then
      { arch = "linux-amd64";
        sha256 = "0p0qj911nmmdj0r7wx3363gid8g4bm3my6mj3d6s4mwgh9lfisiz";
        archiveBinaryPath = "linux/amd64"; }
    else if bsdPredicate then
      { arch = "freebsd-amd64";
        sha256 = "0g618y9n39j11l1cbhyhwlbl2gv5a2a122c1dps3m2wmv7yzq5hk";
        archiveBinaryPath = "freebsd/amd64"; }
    else
      { arch = "darwin-amd64";
        sha256 = "0l623fgnsix0y3f960bwx3dgnrqaxs21w5652kvaaal7dhnlgmwj";
        archiveBinaryPath = "darwin/amd64"; };
in stdenv.mkDerivation rec {
  shortname = "github-release";
  name = "${shortname}-${version}";
  version = "0.7.2";

  src = fetchurl {
    url = "https://github.com/aktau/github-release/releases/download/v${version}/${metadata.arch}-${shortname}.tar.bz2";
    sha256 = metadata.sha256;
  };

  buildInputs = [ ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp "${metadata.archiveBinaryPath}/github-release" "$out/bin/"
  '';

  meta = with stdenv.lib; {
    description = "Commandline app to create and edit releases on Github (and upload artifacts)";
    longDescription = ''
      A small commandline app written in Go that allows you to easily create and
      delete releases of your projects on Github.
      In addition it allows you to attach files to those releases.
    '';

    license = licenses.mit;
    homepage = "https://github.com/aktau/github-release";
    maintainers = with maintainers; [ ardumont ];
    platforms = with platforms; unix;
  };
}
