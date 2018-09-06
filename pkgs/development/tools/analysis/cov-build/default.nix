{ stdenv, requireFile }:

let
  message = ''
    Register an account at https://scan.coverity.com, download the
    build tools, and add it to the nix store with nix-prefetch-url
  '';
in
stdenv.mkDerivation rec {
  name    = "cov-build-${version}";
  version = "7.0.2";

  src =
    if stdenv.hostPlatform.system == "i686-linux"
    then requireFile {
      name = "cov-analysis-linux32-${version}.tar.gz";
      sha256 = "0i06wbd7blgx9adh9w09by4i18vwmldfp9ix97a5dph2cjymsviy";
      inherit message;
    }
    else requireFile {
      name = "cov-analysis-linux64-${version}.tar.gz";
      sha256 = "0iby75p0g8gv7b501xav47milr8m9781h0hcgm1ch6x3qj6irqd8";
      inherit message;
    };

  dontStrip = true;
  buildPhase = false;
  installPhase = ''
    mkdir -p $out/bin $out/libexec
    mv * $out/libexec
    for x in cov-build cov-capture cov-configure cov-emit cov-emit-java \
      cov-export-cva cov-extract-scm cov-help cov-import-scm cov-link \
      cov-internal-clang cov-internal-emit-clang cov-internal-nm \
      cov-internal-emit-java-bytecode cov-internal-reduce cov-translate \
      cov-preprocess cov-internal-pid-to-db cov-manage-emit \
      cov-manage-history; do
        ln -s $out/libexec/bin/$x $out/bin/$x;
    done
  '';

  meta = {
    description = "Coverity Scan build tools";
    homepage    = "https://scan.coverity.com";
    license     = stdenv.lib.licenses.unfreeRedistributable;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
