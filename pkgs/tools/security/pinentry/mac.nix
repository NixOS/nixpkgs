{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, libassuan
, libgpg-error
, libiconv
, texinfo
, common-updater-scripts
, writers
, Cocoa
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

  # use pregenerated nib files because generating them requires XCode
  postPatch = ''
    cp -r ${./mac/Main.nib} macosx/Main.nib
    cp -r ${./mac/Pinentry.nib} macosx/Pinentry.nib
    chmod -R u+w macosx/*.nib
  '';

  nativeBuildInputs = [ autoreconfHook texinfo ];
  buildInputs = [ libassuan libgpg-error libiconv Cocoa ];

  configureFlags = [ "--enable-maintainer-mode" "--disable-ncurses" ];

  installPhase = ''
    mkdir -p $out/Applications
    mv macosx/pinentry-mac.app $out/Applications
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
    homepage = "https://github.com/GPGTools/pinentry-mac";
    platforms = lib.platforms.darwin;
  };
}
