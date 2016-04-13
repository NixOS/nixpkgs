{ stdenv, callPackage, makeWrapper, nodejs, phantomjs2 }:

let
  self = (
    callPackage ../../../top-level/node-packages.nix {
      generated = callPackage ./node-packages.nix { inherit self; };
      overrides = {
        "wring" = {
          buildInputs = [ makeWrapper phantomjs2 ];

          postInstall = ''
            wrapProgram "$out/bin/wring" \
              --prefix PATH : ${phantomjs2}/bin
          '';

          meta = with stdenv.lib; {
            description = "Command-line tool for extracting content from webpages using CSS Selectors, XPath, and JS expressions";
            homepage = https://github.com/osener/wring;
            license = licenses.mit;
            platforms = platforms.darwin ++ platforms.linux;
            maintainers = [ maintainers.osener ];
          };
        };
      };
    });
in self.wring
