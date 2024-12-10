{
  lib,
  stdenv,
  buildFHSEnv,
  corefonts,
  dejavu_fonts,
  dpkg,
  fetchurl,
  gcc-unwrapped,
  liberation_ttf_v1,
  writeScript,
  xorg,
}:

let
  # var/www/onlyoffice/documentserver/server/DocService/docservice
  onlyoffice-documentserver = stdenv.mkDerivation rec {
    pname = "onlyoffice-documentserver";
    version = "7.5.1";

    src = fetchurl {
      url = "https://github.com/ONLYOFFICE/DocumentServer/releases/download/v${lib.concatStringsSep "." (lib.take 3 (lib.splitVersion version))}/onlyoffice-documentserver_amd64.deb";
      sha256 = "sha256-191PYpxs/TbVXoBPHvuyTp81ZMtw1YaFznY1hUSbh+0=";
    };

    preferLocalBuild = true;

    unpackCmd = "dpkg -x $curSrc source";

    nativeBuildInputs = [
      dpkg
    ];

    installPhase = ''
      # replace dangling symlinks which are not copied into fhs with actually files
      rm lib/*.so*
      for file in var/www/onlyoffice/documentserver/server/FileConverter/bin/*.so* ; do
        ln -rs "$file" lib/$(basename "$file")
      done

      # NixOS uses systemd, not supervisor
      rm -rf etc/supervisor

      install -Dm755 usr/bin/documentserver-prepare4shutdown.sh -t $out/bin
      # maintainer scripts which expect supervisorctl, try to write into the nix store or are handled by nixos modules
      rm -rf usr/bin

      # .deb default documentation
      rm -rf usr/share

      # required for bwrap --bind
      mkdir -p var/lib/onlyoffice/ var/www/onlyoffice/documentserver/fonts/

      mv * $out/
    '';

    # stripping self extracting javascript binaries likely breaks them
    dontStrip = true;

    passthru = {
      fhs = buildFHSEnv {
        name = "onlyoffice-wrapper";

        targetPkgs = pkgs: [
          gcc-unwrapped.lib
          onlyoffice-documentserver

          # fonts
          corefonts
          dejavu_fonts
          liberation_ttf_v1
        ];

        extraBwrapArgs = [
          "--bind var/lib/onlyoffice/ var/lib/onlyoffice/"
          "--bind var/lib/onlyoffice/documentserver/sdkjs/common/ var/www/onlyoffice/documentserver/sdkjs/common/"
          "--bind var/lib/onlyoffice/documentserver/sdkjs/slide/themes/ var/www/onlyoffice/documentserver/sdkjs/slide/themes/"
          "--bind var/lib/onlyoffice/documentserver/fonts/ var/www/onlyoffice/documentserver/fonts/"
          "--bind var/lib/onlyoffice/documentserver/server/FileConverter/bin/ var/www/onlyoffice/documentserver/server/FileConverter/bin/"
        ];

        runScript = writeScript "onlyoffice-documentserver-run-script" ''
          export NODE_CONFIG_DIR=$2
          export NODE_DISABLE_COLORS=1
          export NODE_ENV=production-linux

          if [[ $1 == DocService/docservice ]]; then
            mkdir -p var/www/onlyoffice/documentserver/sdkjs/slide/themes/
            # symlinking themes/src breaks discovery in allfontsgen
            rm -rf var/www/onlyoffice/documentserver/sdkjs/slide/themes/src
            cp -r ${onlyoffice-documentserver}/var/www/onlyoffice/documentserver/sdkjs/slide/themes/src var/www/onlyoffice/documentserver/sdkjs/slide/themes/
            chmod -R u+w var/www/onlyoffice/documentserver/sdkjs/slide/themes/

            # onlyoffice places generated files in those directores
            rm -rf var/www/onlyoffice/documentserver/sdkjs/common/*
            ${xorg.lndir}/bin/lndir -silent ${onlyoffice-documentserver}/var/www/onlyoffice/documentserver/sdkjs/common/ var/www/onlyoffice/documentserver/sdkjs/common/
            rm -rf var/www/onlyoffice/documentserver/server/FileConverter/bin/*
            ${xorg.lndir}/bin/lndir -silent ${onlyoffice-documentserver}/var/www/onlyoffice/documentserver/server/FileConverter/bin/ var/www/onlyoffice/documentserver/server/FileConverter/bin/

            # https://github.com/ONLYOFFICE/document-server-package/blob/master/common/documentserver/bin/documentserver-generate-allfonts.sh.m4
            echo -n Generating AllFonts.js, please wait...
            "var/www/onlyoffice/documentserver/server/tools/allfontsgen"\
              --input="${onlyoffice-documentserver}/var/www/onlyoffice/documentserver/core-fonts"\
              --allfonts-web="var/www/onlyoffice/documentserver/sdkjs/common/AllFonts.js"\
              --allfonts="var/www/onlyoffice/documentserver/server/FileConverter/bin/AllFonts.js"\
              --images="var/www/onlyoffice/documentserver/sdkjs/common/Images"\
              --selection="var/www/onlyoffice/documentserver/server/FileConverter/bin/font_selection.bin"\
              --output-web="var/www/onlyoffice/documentserver/fonts"\
              --use-system="true"
            echo Done

            echo -n Generating presentation themes, please wait...
            "var/www/onlyoffice/documentserver/server/tools/allthemesgen"\
              --converter-dir="var/www/onlyoffice/documentserver/server/FileConverter/bin"\
              --src="var/www/onlyoffice/documentserver/sdkjs/slide/themes"\
              --output="var/www/onlyoffice/documentserver/sdkjs/common/Images"

            "var/www/onlyoffice/documentserver/server/tools/allthemesgen"\
              --converter-dir="var/www/onlyoffice/documentserver/server/FileConverter/bin"\
              --src="var/www/onlyoffice/documentserver/sdkjs/slide/themes"\
              --output="var/www/onlyoffice/documentserver/sdkjs/common/Images"\
              --postfix="ios"\
              --params="280,224"

            "var/www/onlyoffice/documentserver/server/tools/allthemesgen"\
              --converter-dir="var/www/onlyoffice/documentserver/server/FileConverter/bin"\
              --src="var/www/onlyoffice/documentserver/sdkjs/slide/themes"\
              --output="var/www/onlyoffice/documentserver/sdkjs/common/Images"\
              --postfix="android"\
              --params="280,224"
            echo Done
          fi

          exec var/www/onlyoffice/documentserver/server/$1
        '';
      };
    };

    meta = with lib; {
      description = "ONLYOFFICE Document Server is an online office suite comprising viewers and editors";
      mainProgram = "documentserver-prepare4shutdown.sh";
      longDescription = ''
        ONLYOFFICE Document Server is an online office suite comprising viewers and editors for texts, spreadsheets and presentations,
        fully compatible with Office Open XML formats: .docx, .xlsx, .pptx and enabling collaborative editing in real time.
      '';
      homepage = "https://github.com/ONLYOFFICE/DocumentServer";
      license = licenses.agpl3Plus;
      platforms = [ "x86_64-linux" ];
      sourceProvenance = [ sourceTypes.binaryNativeCode ];
      maintainers = with maintainers; [ SuperSandro2000 ];
    };
  };
in
onlyoffice-documentserver
