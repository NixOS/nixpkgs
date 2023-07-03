{ lib
, stdenv
, fetchzip
, testers
}:
let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "macOS-x64";
    # Balena only packages for x86 so we rely on Rosetta for Apple Silicon
    aarch64-darwin = "macOS-x64";
  }.${system} or throwSystem;

  sha256 = {
    x86_64-linux = "sha256-yNyQ3cmy0Rc2+8EygMJwB/kmmmOiyq5V+7dyFFHyaVA=";
    x86_64-darwin = "sha256-sODceZObYQned+opKQ4BgRZxlJQ12c2D01+FG8JF2N0=";
    aarch64-darwin = "sha256-sODceZObYQned+opKQ4BgRZxlJQ12c2D01+FG8JF2N0=";
  }.${system} or throwSystem;

  version = "16.6.2";
  src = fetchzip {
    url = "https://github.com/balena-io/balena-cli/releases/download/v${version}/balena-cli-v${version}-${plat}-standalone.zip";
    inherit sha256;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "balena-cli";
  inherit version src;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r ./* $out/
    ln -s $out/balena $out/bin/balena

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = ''
      # Override default cache directory so Balena CLI's unavoidable update check does not fail due to write permissions
      BALENARC_DATA_DIRECTORY=./ balena --version
    '';
    inherit version;
  };

  # https://github.com/NixOS/nixpkgs/pull/48193/files#diff-b65952dbe5271c002fbc941b01c3586bf5050ad0e6aa6b2fcc74357680e103ea
  preFixup =
    if stdenv.isLinux then
      let
        libPath = lib.makeLibraryPath [ stdenv.cc.cc ];
      in
      ''
        orig_size=$(stat --printf=%s $out/balena)
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/balena
        patchelf --set-rpath ${libPath} $out/balena
        chmod +x $out/balena
        new_size=$(stat --printf=%s $out/balena)
        ###### zeit-pkg fixing starts here.
        # we're replacing plaintext js code that looks like
        # PAYLOAD_POSITION = '1234                  ' | 0
        # [...]
        # PRELUDE_POSITION = '1234                  ' | 0
        # ^-----20-chars-----^^------22-chars------^
        # ^-- grep points here
        #
        # var_* are as described above
        # shift_by seems to be safe so long as all patchelf adjustments occur
        # before any locations pointed to by hardcoded offsets
        var_skip=20
        var_select=22
        shift_by=$(expr $new_size - $orig_size)
        function fix_offset {
          # $1 = name of variable to adjust
          location=$(grep -obUam1 "$1" $out/bin/balena | cut -d: -f1)
          location=$(expr $location + $var_skip)
          value=$(dd if=$out/balena iflag=count_bytes,skip_bytes skip=$location \
                     bs=1 count=$var_select status=none)
          value=$(expr $shift_by + $value)
          echo -n $value | dd of=$out/balena bs=1 seek=$location conv=notrunc
        }
        fix_offset PAYLOAD_POSITION
        fix_offset PRELUDE_POSITION
      '' else '''';
  dontStrip = true;

  meta = with lib; {
    description = "A command line interface for balenaCloud or openBalena";
    longDescription = ''
      The balena CLI is a Command Line Interface for balenaCloud or openBalena. It is a software
      tool available for Windows, macOS and Linux, used through a command prompt / terminal window.
      It can be used interactively or invoked in scripts. The balena CLI builds on the balena API
      and the balena SDK, and can also be directly imported in Node.js applications.
    '';
    homepage = "https://github.com/balena-io/balena-cli";
    changelog = "https://github.com/balena-io/balena-cli/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ maintainers.kalebpace ];
    platforms = platforms.linux ++ platforms.darwin;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    mainProgram = "balena";
  };
})
