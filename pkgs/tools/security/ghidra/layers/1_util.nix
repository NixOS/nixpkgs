self: super: {
    config = {
      pkg_path = "lib/ghidra";
      ghidraDevPath = self.config.pkg_path + "/Extensions/Eclipse/GhidraDev/GhidraDev-2.0.0.zip";
      ghidraDevVersion = "2.0.0";
      launchers = [
          "ghidraRun" "support/analyzeHeadless" "support/buildGhidraJar"
          "support/convertStorage" "support/dumpGhidraThreads" "support/ghidraDebug"
          "support/pythonRun" "support/sleigh"
          ];
      defaultOpts = import ../lib/defaultOpts.nix;
      };


    lib = {
      # nix-shell -p nix-prefetch-github --run "nix-prefetch-github owner repo > ./plugins/json/theplugin.json"
      fetchGitHubJSON = {JSONfile, ...}@args:
        self.pkgs.fetchFromGitHub ({ inherit (self.pkgs.lib.importJSON JSONfile) owner repo rev sha256; } // (
          builtins.removeAttrs args [ "JSONfile" ]
          ));

      # { args ? defaultOpts.args, debug ? defaultOpts.debug }: # The signature
      mkRunline = self.callPackage ((import ../lib/mkRunline.nix) self.config.defaultOpts) {};

      poorMkGradle = self.callPackage ../lib/poorMkGradle.nix {};

      jdkWrapper = src: dst: ''
        makeWrapper "$out/${src}" "$out/${dst}" \
          --prefix PATH : '${self.pkgs.lib.makeBinPath [ self.jdk ]}' \
          --run '. ${self.jdk}/nix-support/setup-hook' #set JAVA_HOME
        '';

      writeCustomLauncher = name: content: ''
        cp -- "${self.pkgs.writeShellScriptBin name content}/bin/${name}" "$out/bin/.${name}"
        ${self.lib.jdkWrapper "bin/.${name}" "bin/${name}" }
        '';

      # hash-name -> name
      nameOf = i: with self.pkgs.lib;
        let dropHash = s: concatStringsSep "-" (tail (splitString "-" s)); in
          dropHash (removeSuffix ".zip" (builtins.baseNameOf i));

      unpackPlugin = pluginZip:
        self.pkgs.stdenv.mkDerivation {
          name = builtins.unsafeDiscardStringContext (self.lib.nameOf pluginZip);
          phases = [ "unpackPhase" "installPhase" ];
          buildInputs = [ self.pkgs.unzip ];
          src = pluginZip;
          installPhase = ''
            mkdir -p -- "$out"
            cp -r -- ./* "$out"
            '';
          };

      #TODO mk extracted plugin derivation and ln that? <--use multiple output?
      installPlugin = plugin: ''
        ln -s -- "${plugin}" "$out/${self.config.pkg_path}/Ghidra/Extensions/${self.lib.nameOf (builtins.baseNameOf plugin)}"
        '';
      };


    withPlugins = f: self.ghidra.override { plugins = f self; };
    }
