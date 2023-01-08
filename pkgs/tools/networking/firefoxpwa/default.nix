{ stdenv
, rustPlatform
, fetchFromGitHub
, openssl
, symlinkJoin
, buildFHSUserEnv
, pkg-config
, installShellFiles
, bintools
, bzip2
, lib
}:
let
  version = "2.7.3";
  dir = "native";
  source = fetchFromGitHub {
    owner = "filips123";
    repo = "PWAsForFirefox";
    rev = "v${version}";
    sha256 = "sha256-TCqSrJqq6QLPFpNdLruTI1uYrV3cQvHFomhbCSrvSic=";
    sparseCheckout = [ dir ];
  };
  pname = "firefoxpwa";

  unwrapped = rustPlatform.buildRustPackage {
    inherit version;
    pname = "${pname}-unwrapped";

    src = "${source}/${dir}";
    cargoLock = {
      lockFile = "${unwrapped.src}/Cargo.lock";
      outputHashes = {
         "data-url-0.3.0" = "sha256-SDOOwwvZrX4i04NElBJe5NRS9MXCgRVhBz7L4G8B4m8=";
         "mime-0.4.0-a.0" = "sha256-LjM7LH6rL3moCKxVsA+RUL9lfnvY31IrqHa9pDIAZNE=";
         "web_app_manifest-0.0.0" = "sha256-G+kRN8AEmAY1TxykhLmgoX8TG8y2lrv7SCRJlNy0QzA=";
       };
    };

    nativeBuildInputs = [ pkg-config installShellFiles bintools ];
    buildInputs = [ openssl bzip2 ];

    # cannot be postPatch otherwise cargo complains in cargoSetupPostPatchHook
    # thinks Cargo.lock is out of date
    # instead upstream did not want to update version field in Cargo.lock
    # https://github.com/NixOS/nixpkgs/pull/215905#discussion_r1149660722
    # so we have to do it manually like they do in their GitHub Action
    # https://github.com/filips123/PWAsForFirefox/blob/master/.github/workflows/native.yaml#L200
    preConfigure = ''
      sed -i 's;version = "0.0.0";version = "${version}";' Cargo.toml
      sed -zi 's;name = "firefoxpwa"\nversion = "0.0.0";name = "firefoxpwa"\nversion = "${version}";' Cargo.lock
      sed -i $'s;DISTRIBUTION_VERSION = \'0.0.0\';DISTRIBUTION_VERSION = \'${version}\';' userchrome/profile/chrome/pwa/chrome.jsm
    '';

    FFPWA_EXECUTABLES = ""; # .desktop entries generated without any store path references
    FFPWA_SYSDATA = "${placeholder "out"}/share/firefoxpwa";
    completions = "target/${stdenv.targetPlatform.config}/release/completions";

    postInstall = ''
      mv $out/bin/firefoxpwa $out/bin/.firefoxpwa-wrapped

      # Manifest
      sed -i "s!/usr/libexec!$out/bin!" manifests/linux.json
      install -Dm644 manifests/linux.json $out/lib/mozilla/native-messaging-hosts/firefoxpwa.json

      installShellCompletion --cmd firefoxpwa \
        --bash $completions/firefoxpwa.bash \
        --fish $completions/firefoxpwa.fish \
        --zsh $completions/_firefoxpwa

      # UserChrome
      mkdir -p $out/share/firefoxpwa/userchrome/
      cp -r userchrome/* "$out/share/firefoxpwa/userchrome"
    '';
  };

  # firefoxpwa wants to run binaries downloaded into users' home dir
  fhs = buildFHSUserEnv {
    name = pname;
    runScript = "${unwrapped}/bin/.firefoxpwa-wrapped";
    targetPkgs = pkgs: with pkgs;[
      dbus-glib
      gtk3
      alsaLib
      xorg.libXtst
      xorg.libX11
    ];
  };
in
(symlinkJoin {
  name = "${pname}-${version}";
  paths = [ fhs unwrapped ];
}) // {
  inherit unwrapped fhs pname version;
  meta = with lib;{
    description = "Tool to install, manage and use Progressive Web Apps (PWAs) in Mozilla Firefox";
    homepage = "https://github.com/filips123/PWAsForFirefox";
    maintainers = with maintainers;[ pasqui23 ];
    license = licenses.mpl20;
    platform = [ platforms.unix ];
  };
}
