{
  callPackage,
  cmake,
  fetchgit,
  fetchurl,
  makeWrapper,
  nodePackages,
  nodejs-6_x,
  pandoc,
  python2,
  rPackages,
  rWrapper,
  runCommand,
  stdenv,
  extraRPackages ? [],
  ... }:

with stdenv.lib;

let
  # The nodejs version must match nodeHeaders below.
  nodejs = nodejs-6_x;
  nodeHeaders = fetchurl {
    url = "https://nodejs.org/download/release/v6.11.5/node-v6.11.5-headers.tar.gz";
    sha256 = "10syimf5vbdky1r78brxxw1h5qh7yyrf54h5qc6hlb8z5m0v4nly";
  };

  shinyPackages = (callPackage ./composition.nix {}).package.override (o: {
    dontNpmInstall = true;
    # The native node library is not built automatically.
    preRebuild = ''
      export HOME=$PWD
      echo "building native library"
      ${nodePackages.node-gyp}/bin/node-gyp --production --tarball=${nodeHeaders} rebuild
    '';
  });

  rWrapper_ = rWrapper.override {
    packages = with rPackages; [ shiny rmarkdown ggplot2 ] ++ extraRPackages;
  };
in
stdenv.mkDerivation rec {
  name = "shiny-server-${version}";
  version = "v1.5.5.872";

  src = shinyPackages.src;
  buildInputs = [ cmake python2 makeWrapper pandoc ];

  # Inject pandoc, node and node_modules from nix instead of letting
  # Shiny compile its own.
  preConfigure = ''
    echo > external/pandoc/CMakeLists.txt
    echo > external/node/CMakeLists.txt

    ln -s ${shinyPackages}/lib/node_modules/shiny-server/node_modules node_modules
    mkdir -p ext/node/bin
    ln -s ${nodejs}/bin/node ext/node/bin/shiny-server
  '';

  postInstall = ''
    mkdir -p $out/shiny-server/build
    ln -s ${shinyPackages}/lib/node_modules/shiny-server/build/Release $out/shiny-server/build/Release
    printenv
    wrapProgram $out/shiny-server/bin/shiny-server \
      --prefix PATH : "${stdenv.lib.makeBinPath [ rWrapper_ pandoc ]}" \
      --set R_LIBS_SITE : $R_LIBS_SITE
    mkdir -p $out/bin
    ln -s $out/shiny-server/bin/shiny-server $out/bin/shiny-server
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.rstudio.com/products/shiny/shiny-server/";
    description = "Serves web applications written in the R Shiny framework";
    license = licenses.agpl3;
    longDescription = ''
      Shiny Server is a server program that makes Shiny applications available
      over the web. Shiny is an R package that uses a reactive programming model
      to simplify the development of R-powered web applications.
    '';
    platforms = platforms.linux;
    maintainers = with maintainers; [ orbekk ];
  };
}
