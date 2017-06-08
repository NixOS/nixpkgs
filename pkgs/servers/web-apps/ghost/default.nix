{ stdenv
, nodejs
, fetchzip
, utillinux
, runCommand
, callPackage
, ... } @ args:

let
  nodePackages = callPackage (import ../../../top-level/node-packages.nix) {
    inherit stdenv nodejs;
    neededNatives = stdenv.lib.optional stdenv.isLinux utillinux;
    self = nodePackages;
    generated = ./node-packages.nix;
  };
  src = [
    (with rec {
      zipfile = (fetchzip {
        url = "https://github.com/TryGhost/Ghost/releases/download/0.11.9/Ghost-0.11.9.zip";
        sha1 = "i862dy43ayssql15bjy0d8mz77hb2704";
        stripRoot = false;
      });
    }; runCommand "ghost-0.11.9.tgz" { buildInputs = [ nodejs ]; } ''
         mv `HOME=$PWD npm pack ${zipfile}` $out
       '')
  ];
in
nodePackages.buildNodePackage ({
  name = "ghost-0.11.9";
  inherit src;

  meta = with stdenv.lib; {
    description = "Just a blogging platform";
    homepage = https://ghost.org;
    license = licenses.mit;
    platforms = platforms.all;
    longDescription = ''
      Ghost is an open source publishing platform which is beautifully designed, easy to use, and free for everyone.

      To use, you need further configuration (such as database settings),
      you can use ghost_configurable.
    '';
  };

  patchPhase = ''
    # Somehow Knex wants mysql and pg to be inside package.json
    # remove them from optional dependencies, move them to dependencies
    substituteInPlace package.json --replace '"mysql": "2.1.1",'
    substituteInPlace package.json --replace '"pg": "6.1.2"'
    substituteInPlace package.json --replace '"xml": "1.0.1"' '"xml": "1.0.1","mysql": "2.1.1","pg": "6.1.2"'
  '';

  deps = [
    nodePackages.by-spec."amperize"."0.3.4"
    nodePackages.by-spec."archiver"."1.3.0"
    nodePackages.by-spec."bcryptjs"."2.4.3"
    nodePackages.by-spec."bluebird"."3.5.0"
    nodePackages.by-spec."body-parser"."1.17.0"
    nodePackages.by-spec."bookshelf"."0.10.2"
    nodePackages.by-spec."chalk"."1.1.3"
    nodePackages.by-spec."cheerio"."0.22.0"
    nodePackages.by-spec."compression"."1.6.2"
    nodePackages.by-spec."connect-slashes"."1.3.1"
    nodePackages.by-spec."cookie-session"."1.2.0"
    nodePackages.by-spec."cors"."2.8.3"
    nodePackages.by-spec."csv-parser"."1.11.0"
    nodePackages.by-spec."downsize"."0.0.8"
    nodePackages.by-spec."express"."4.15.0"
    nodePackages.by-spec."express-hbs"."1.0.4"
    nodePackages.by-spec."extract-zip-fork"."1.5.1"
    nodePackages.by-spec."fs-extra"."2.1.2"
    nodePackages.by-spec."ghost-gql"."0.0.6"
    nodePackages.by-spec."glob"."5.0.15"
    nodePackages.by-spec."gscan"."0.2.4"
    nodePackages.by-spec."html-to-text"."3.2.0"
    nodePackages.by-spec."image-size"."0.5.1"
    nodePackages.by-spec."intl"."1.2.5"
    nodePackages.by-spec."intl-messageformat"."1.3.0"
    nodePackages.by-spec."jsonpath"."0.2.11"
    nodePackages.by-spec."knex"."0.12.9"
    nodePackages.by-spec."lodash"."4.17.4"
    nodePackages.by-spec."moment"."2.18.1"
    nodePackages.by-spec."moment-timezone"."0.5.13"
    nodePackages.by-spec."morgan"."1.7.0"
    nodePackages.by-spec."multer"."1.3.0"
    nodePackages.by-spec."netjet"."1.1.3"
    nodePackages.by-spec."nodemailer"."0.7.1"
    nodePackages.by-spec."oauth2orize"."1.8.0"
    nodePackages.by-spec."passport"."0.3.2"
    nodePackages.by-spec."passport-http-bearer"."1.0.1"
    nodePackages.by-spec."passport-oauth2-client-password"."0.1.2"
    nodePackages.by-spec."path-match"."1.2.4"
    nodePackages.by-spec."rss"."1.2.2"
    nodePackages.by-spec."sanitize-html"."1.14.1"
    nodePackages.by-spec."semver"."5.3.0"
    nodePackages.by-spec."showdown-ghost"."0.3.6"
    nodePackages.by-spec."sqlite3"."3.1.8"
    nodePackages.by-spec."superagent"."3.5.2"
    nodePackages.by-spec."unidecode"."0.1.8"
    nodePackages.by-spec."uuid"."3.0.0"
    nodePackages.by-spec."validator"."6.3.0"
    nodePackages.by-spec."xml"."1.0.1"
    nodePackages.by-spec."mysql"."2.1.1"
    nodePackages.by-spec."pg"."6.1.2"
  ];
  peerDependencies = [];
} // (stdenv.lib.filterAttrs (n: v: stdenv.lib.all (k: n != k) ["stdenv" "nodejs" "fetchzip" "utillinux" "runCommand" "callPackage"]) args))
