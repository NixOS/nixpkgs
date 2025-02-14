{
  stdenv,
  fetchurl,
  lib,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "wiki-js";
  version = "2.5.306";

  src = fetchurl {
    url = "https://github.com/Requarks/wiki/releases/download/v${version}/${pname}.tar.gz";
    sha256 = "sha256-BYJTzPUfd+eYRzHuNVO/L3NvGej0pBnWL6+7AjiGJ/Q=";
  };

  # Unpack the tarball into a subdir. All the contents are copied into `$out`.
  # Unpacking into the parent directory would also copy `env-vars` into `$out`
  # in the `installPhase` which ultimately means that the package retains
  # references to build tools and the tarball.
  preUnpack = ''
    mkdir source
    cd source
  '';

  sourceRoot = ".";

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r . $out

    runHook postInstall
  '';

  passthru = {
    tests = { inherit (nixosTests) wiki-js; };
    updateScript = ./update.sh;
  };

  meta = with lib; {
    homepage = "https://js.wiki/";
    description = "Modern and powerful wiki app built on Node.js";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ma27 ];
  };
}
