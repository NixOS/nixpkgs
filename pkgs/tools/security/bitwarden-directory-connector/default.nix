{
  lib,
  buildNpmPackage,
  electron,
  fetchFromGitHub,
  buildPackages,
  python3,
  pkg-config,
  libsecret,
  nodejs_18,
}:

let
  common =
    {
      name,
      npmBuildScript,
      installPhase,
    }:
    buildNpmPackage rec {
      pname = name;
      version = "2024.10.0";
      nodejs = nodejs_18;

      src = fetchFromGitHub {
        owner = "bitwarden";
        repo = "directory-connector";
        rev = "v${version}";
        hash = "sha256-jisMEuIpTWCy+N1QeERf+05tsugY0f+H2ntcRcFKkgo=";
      };

      postPatch = ''
        ${lib.getExe buildPackages.jq} 'del(.scripts.preinstall)' package.json > package.json.tmp
        mv -f package.json{.tmp,}

        substituteInPlace electron-builder.json \
          --replace-fail '"afterSign": "scripts/notarize.js",' "" \
          --replace-fail "AppImage" "dir"
      '';

      npmDepsHash = "sha256-Zi7EHzQSSrZ6XGGV1DOASuddYA4svXQc1eGmchcLFBc=";

      env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

      makeCacheWritable = true;
      inherit npmBuildScript installPhase;

      buildInputs = [
        libsecret
      ];

      nativeBuildInputs = [
        (python3.withPackages (ps: with ps; [ setuptools ]))
        pkg-config
      ];

      meta = with lib; {
        description = "LDAP connector for Bitwarden";
        homepage = "https://github.com/bitwarden/directory-connector";
        license = licenses.gpl3Only;
        maintainers = with maintainers; [
          Silver-Golden
          SuperSandro2000
        ];
        platforms = platforms.linux;
        mainProgram = name;
      };
    };
in
{
  bitwarden-directory-connector = common {
    name = "bitwarden-directory-connector";
    npmBuildScript = "build:dist";
    installPhase = ''
      runHook preInstall

      npm exec electron-builder -- \
        --dir \
        -c.electronDist=${electron.dist} \
        -c.electronVersion=${electron.version} \
        -c.npmRebuild=false

      mkdir -p $out/share/bitwarden-directory-connector $out/bin
      cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/bitwarden-directory-connector

      makeWrapper ${lib.getExe electron} $out/bin/bitwarden-directory-connector \
        --add-flags $out/share/bitwarden-directory-connector/resources/app.asar \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
        --set-default ELECTRON_IS_DEV 0 \
        --inherit-argv0

      runHook postInstall
    '';
  };

  bitwarden-directory-connector-cli = common {
    name = "bitwarden-directory-connector-cli";
    npmBuildScript = "build:cli:prod";
    installPhase = ''
      runHook preInstall

      mkdir -p $out/libexec/bitwarden-directory-connector
      cp -R build-cli node_modules $out/libexec/bitwarden-directory-connector

      # needs to be wrapped with nodejs so that it can be executed
      chmod +x $out/libexec/bitwarden-directory-connector/build-cli/bwdc.js
      mkdir -p $out/bin
      ln -s $out/libexec/bitwarden-directory-connector/build-cli/bwdc.js $out/bin/bitwarden-directory-connector-cli

      runHook postInstall
    '';
  };
}
