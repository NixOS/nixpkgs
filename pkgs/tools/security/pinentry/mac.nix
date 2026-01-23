{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libassuan,
  libgpg-error,
  makeBinaryWrapper,
  texinfo,
  xcbuild,
  common-updater-scripts,
  writers,
}:

stdenv.mkDerivation rec {
  pname = "pinentry-mac";

  # NOTE: Don't update manually. Use passthru.updateScript on a Mac with XCode
  # installed.
  version = "1.1.1.1";

  src = fetchFromGitHub {
    owner = "GPGTools";
    repo = "pinentry";
    rev = "v${version}";
    sha256 = "sha256-QnDuqFrI/U7aZ5WcOCp5vLE+w59LVvDGOFNQy9fSy70=";
  };

  patches = [
    ./gettext-0.25.patch

    # Fix the build with xcbuild’s inferior `PlistBuddy(8)`.
    ./fix-with-xcbuild-plistbuddy.patch
  ];

  # use pregenerated nib files because generating them requires XCode
  postPatch = ''
    cp -r ${./mac/Main.nib} macosx/Main.nib
    cp -r ${./mac/Pinentry.nib} macosx/Pinentry.nib
    chmod -R u+w macosx/*.nib
    # pinentry_mac requires updated macros to correctly detect v2 API support in libassuan 3.x.
    cp '${lib.getDev libassuan}/share/aclocal/libassuan.m4' m4/libassuan.m4
  '';

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    makeBinaryWrapper
    texinfo

    # for `PlistBuddy(8)`
    xcbuild
  ];

  configureFlags = [
    "--enable-maintainer-mode"
    "--disable-ncurses"
    "--with-libgpg-error-prefix=${libgpg-error.dev}"
    "--with-libassuan-prefix=${libassuan.dev}"
  ];

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

      main() {
        tag="$(queryLatestTag)"
        ver="$(expr "$tag" : 'v\(.*\)')"

        ${common-updater-scripts}/bin/update-source-version pinentry_mac "$ver"

        cd ${lib.escapeShellArg ./.}
        rm -rf mac
        mkdir mac

        srcDir="$(nix-build ../../../.. --no-out-link -A pinentry_mac.src)"
        for path in "$srcDir"/macosx/*.xib; do
          filename="''${path##*/}"
          /usr/bin/ibtool --compile "mac/''${filename%.*}.nib" "$path"
        done
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
