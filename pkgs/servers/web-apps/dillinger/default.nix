{ stdenv, pkgs, buildEnv, fetchFromGitHub, makeWrapper, nodejs, phantomjs }:
let
  nodePackages = import ./node.nix {
    inherit pkgs;
    system = stdenv.system;
  };

  phantomjs-prebuilt = nodePackages."phantomjs-prebuilt-2.1.16".override (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.phantomjs2 ];
    QT_QPA_PLATFORM = "offscreen";
  });

  phantom = nodePackages."phantom-^2.0.4".override (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.phantomjs2 ];
    QT_QPA_PLATFORM = "offscreen";
  });

  runtimeEnv = buildEnv {
    name = "dillinger-runtime";
    paths = [
      phantomjs-prebuilt
      phantom
    ] ++ (stdenv.lib.flip map [
      "angular-^1.3.0"
      "angular-bootstrap-^0.12.0"
      "body-parser-^1.14.1"
      "brace-^0.4.0"
      "breakdance-^0.1.5"
      "colors-^1.1.2"
      "compression-^1.5.2"
      "connect-^3.4.0"
      "cookie-parser-^1.4.0"
      "cookie-session-^1.2.0"
      "dbox-^0.6.4"
      "debug-^2.2.0"
      "depd-^1.1.0"
      "dropbox-^2.5.10"
      "ejs-^2.3.4"
      "errorhandler-^1.4.2"
      "es6-promise-^3.0.2"
      "express-^4.13.3"
      "googleapis-^2.1.5"
      "gulp-gzip-^1.4.0"
      "gulp-tar-^1.9.0"
      "highlight.js-^8.8.0"
      "inverseresize-git+https://github.com/CCole/alsoResizeInverse.git"
      "jquery-^2.1.1"
      "jquery-ui-bundle-^1.11.4"
      "katex-^0.2.0"
      "keymaster-^1.6.2"
      "lodash-^4.15.0"
      "markdown-it-^4.4.0"
      "markdown-it-abbr-^1.0.4"
      "markdown-it-checkbox-^1.1.0"
      "markdown-it-deflist-^1.0.0"
      "markdown-it-footnote-^1.0.0"
      "markdown-it-ins-^1.0.0"
      "markdown-it-mark-^1.0.0"
      "markdown-it-math-^3.0.2"
      "markdown-it-sub-^1.0.0"
      "markdown-it-sup-^1.0.0"
      "markdown-it-toc-^1.1.0"
      "medium-sdk-0.0.4"
      "method-override-^2.3.5"
      "morgan-^1.6.1"
      "netjet-^1.1.3"
      "parse-link-header-0.4.1"
      "rc-0.3.0"
      "request-^2.64.0"
      "serve-favicon-^2.3.0"
      "serve-static-^1.10.0"
      "temp-^0.8.3"
      "webpack-^1.14.0"
    ] (dep: nodePackages."${dep}"));
  };

  name = "dillinger-${version}";
  version = "2017-10-08";

  src = stdenv.mkDerivation {
    name = "${name}-src";
    inherit version;

    src = fetchFromGitHub {
      owner = "joemccann";
      repo = "dillinger";
      rev = "cce09d93619ad4c481014b4c8f8b95a7ec10b67a";
      sha256 = "0z1dh5i8w97ira7fy7zjfdyp76kyq5znv4s4k5068g8wrdq5xsa3";
    };

    dontBuild = true;

    installPhase = ''
      mkdir $out
      cp -R . $out
    '';
  };
in
stdenv.mkDerivation rec {
  inherit name version src;

  buildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cat > $out/bin/dillinger <<EOF
      #!${stdenv.shell}/bin/sh
      ${nodejs}/bin/node ${src}/app.js
    EOF
  '';

  postFixup = ''
    chmod +x $out/bin/dillinger
    wrapProgram $out/bin/dillinger \
      --set NODE_PATH "${runtimeEnv}/lib/node_modules:${phantomjs-prebuilt}" \
      --set QT_QPA_PLATFORM "offscreen"
  '';

  meta = with stdenv.lib; {
    description = "A cloud-enabled, mobile-ready, offline-storage, AngularJS powered HTML5 Markdown editor";
    license = licenses.mit;
    homepage = https://dillinger.io;
    maintainers = with maintainers; [ willibutz ];
    platforms = platforms.linux;
  };
}
