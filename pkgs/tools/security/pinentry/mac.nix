{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libassuan,
  libgpg-error,
  makeBinaryWrapper,
  texinfo,
  common-updater-scripts,
  writers,
  re-plistbuddy,
}:

stdenv.mkDerivation rec {
  pname = "pinentry-mac";

  # NOTE: Don't update manually. Use passthru.updateScript on a Mac with XCode
  # installed.
  version = "1.3.1.1";

  src = fetchFromGitHub {
    owner = "GPGTools";
    repo = "pinentry";
    rev = "v${version}";
    sha256 = "sha256-iVd8Gy8XhQOHCSY7caP2QCgs/MufA+p9RN2pNilrJ9E=";
  };

  patches = [
    ./gettext-0.25.patch
  ];

  # use pregenerated nib files because generating them requires XCode
  postPatch = ''
    cp -r ${./mac/Main.nib} macosx/Main.nib
    cp -r ${./mac/Pinentry.nib} macosx/Pinentry.nib
    chmod -R u+w macosx/*.nib
    substituteInPlace macosx/copyInfoPlist.sh \
      --replace-fail "/usr/libexec/PlistBuddy" "PlistBuddy"
  '';

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    makeBinaryWrapper
    texinfo
    re-plistbuddy
  ];

  configureFlags = [
    "--enable-maintainer-mode"
    "--disable-ncurses"
    "--with-libgpg-error-prefix=${libgpg-error.dev}"
    "--with-libassuan-prefix=${libassuan.dev}"
  ];

  # Silence incompatible pointer types errors building KeychainSupport.m.
  env.OBJCFLAGS = "-Wno-error=incompatible-pointer-types";

  installPhase = ''
    mkdir -p $out/Applications $out/bin
    mv macosx/pinentry-mac.app $out/Applications

    # Compatibility with `lib.getExe`
    makeWrapper $out/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac $out/bin/pinentry-mac
  '';

  enableParallelBuilding = true;

  passthru = {
    binaryPath = "Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac";
    updateScript = writers.writeBash "update-pinentry-mac" ''
      set -euxo pipefail

      # Avoid using the SDK from Nixpkgs
      unset DEVELOPER_DIR
      unset SRCROOT

      main() {
        macNix=$(nix-instantiate --eval --strict -A "pinentry_mac.meta.position" | sed -re 's/^"(.*):[0-9]+"$/\1/')
        pinentry_macDir=$(dirname "$macNix")

        tag="$(queryLatestTag)"
        ver="$(expr "$tag" : 'v\(.*\)')"

        ${common-updater-scripts}/bin/update-source-version pinentry_mac "$ver"

        pushd "$pinentry_macDir"

        rm -rf mac
        mkdir mac

        srcDir="$(nix-build ../../../.. --no-out-link -A pinentry_mac.src)"
        for path in "$srcDir"/macosx/*.xib; do
          filename="''${path##*/}"
          /usr/bin/ibtool --compile "mac/''${filename%.*}.nib" "$path"
        done

        popd
      }

      queryLatestTag() {
        curl -sS https://api.github.com/repos/GPGTools/pinentry/tags \
          | jq -r '.[] | .name' | sort --version-sort | tail -1
      }

      main
    '';
  };

  meta = {
    description = "Pinentry for GPG on Mac";
    license = lib.licenses.gpl2Plus;
    homepage = "https://github.com/GPGTools/pinentry";
    platforms = lib.platforms.darwin;
    mainProgram = "pinentry-mac";
  };
}
