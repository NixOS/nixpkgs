{ stdenv, lib, fetchurl, zlib, unzip }:

stdenv.mkDerivation rec {
  pname = "sauce-connect";
  version = "4.9.1";

  passthru = {
    sources = {
      x86_64-linux = fetchurl {
        url = "https://saucelabs.com/downloads/sc-${version}-linux.tar.gz";
        hash = "sha256-S3vzng6b0giB6Zceaxi62pQOEHysIR/vVQmswkEZ0/M=";
      };
      x86_64-darwin = fetchurl {
        url = "https://saucelabs.com/downloads/sc-${version}-osx.zip";
        hash = "sha256-6tJayqo+p7PMz8M651ikHz6tEjGjRIffOqQBchkpW5Q=";
      };
      aarch64-darwin = passthru.sources.x86_64-darwin;
    };
  };

  src = passthru.sources.${stdenv.hostPlatform.system}
    or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ unzip ];

  patchPhase = lib.optionalString stdenv.isLinux ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$out/lib:${lib.makeLibraryPath [zlib]}" \
      bin/sc
  '';

  installPhase = ''
    mkdir -p $out
    cp -r * $out
  '';

  dontStrip = true;

  meta = with lib; {
    description = "A secure tunneling app for executing tests securely when testing behind firewalls";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    homepage = "https://docs.saucelabs.com/reference/sauce-connect/";
    maintainers = with maintainers; [ offline ];
    platforms = builtins.attrNames passthru.sources;
  };
}
