{ stdenv, fetchurl }:

let
  linuxPredicate = stdenv.hostPlatform.system == "x86_64-linux";
  bsdPredicate = stdenv.hostPlatform.system == "x86_64-freebsd";
  darwinPredicate = stdenv.hostPlatform.system == "x86_64-darwin";
  metadata = assert linuxPredicate || bsdPredicate || darwinPredicate;
    if linuxPredicate then
      { arch = "linux-amd64";
        sha256 = "0b3h0d0qsrjx99kcd2cf71xijh44wm5rpm2sr54snh3f7macj2p1";
        archiveBinaryPath = "linux/amd64"; }
    else if bsdPredicate then
      { arch = "freebsd-amd64";
        sha256 = "1yydm4ndkh80phiwk41kcf6pizvwrfhsfk3jwrrgr42wsnkkgj0q";
        archiveBinaryPath = "freebsd/amd64"; }
    else
      { arch = "darwin-amd64";
        sha256 = "1dj74cf1ahihia2dr9ii9ky0cpmywn42z2iq1vkbrrcggjvyrnlf";
        archiveBinaryPath = "darwin/amd64"; };
in stdenv.mkDerivation rec {
  shortname = "github-release";
  name = "${shortname}-${version}";
  version = "0.6.2";

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
    homepage = https://github.com/aktau/github-release;
    maintainers = with maintainers; [ ardumont ];
    platforms = with platforms; unix;
  };
}
