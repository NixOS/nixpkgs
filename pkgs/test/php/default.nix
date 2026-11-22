{
  lib,
  php,
  runCommand,
  stdenv,
  stdenvAdapters,
}:

let
  runTest =
    name: body:
    runCommand name { } ''
      testFailed=
      checking() {
        echo -n "Checking $1... " > /dev/stderr
      }
      ok() {
        echo ok > /dev/stderr
      }
      nok() {
        echo fail > /dev/stderr
        testFailed=1
      }

      ${body}

      if test -n "$testFailed"; then
        exit 1
      fi

      touch $out
    '';

  check = cond: if cond then "ok" else "nok";
in
{
  withExtensions-enables-previously-disabled-extensions = runTest "php-test-withExtensions-enables-previously-disabled-extensions" ''
    php="${php}"

    checking "that imagick is not present by default"
    $php/bin/php -r 'exit(extension_loaded("imagick") ? 1 : 0);' && ok || nok

    phpWithImagick="${php.withExtensions ({ all, ... }: [ all.imagick ])}"
    checking "that imagick extension is present when enabled"
    $phpWithImagick/bin/php -r 'exit(extension_loaded("imagick") ? 0 : 1);' && ok || nok
  '';

  overrideAttrs-preserves-enabled-extensions =
    let
      customPhp = (php.withExtensions ({ all, ... }: [ all.imagick ])).overrideAttrs (attrs: {
        postInstall = attrs.postInstall or "" + ''
          touch "$out/oApee-was-here"
        '';
      });
    in
    runTest "php-test-overrideAttrs-preserves-enabled-extensions" ''
      php="${customPhp}"
      phpUnwrapped="${customPhp.unwrapped}"

      checking "if overrides took hold"
      test -f "$phpUnwrapped/oApee-was-here" && ok || nok

      checking "if imagick extension is still present"
      $php/bin/php -r 'exit(extension_loaded("imagick") ? 0 : 1);' && ok || nok

      checking "if imagick extension is linked against the overridden PHP"
      echo $php
      $php/bin/php -r 'exit(extension_loaded("imagick") ? 0 : 1);' && ok || nok
    '';

  unwrapped-overrideAttrs-stacks =
    let
      customPhp = lib.pipe php.unwrapped [
        (
          pkg:
          pkg.overrideAttrs (attrs: {
            postInstall = attrs.postInstall or "" + ''
              touch "$out/oAs-first"
            '';
          })
        )

        (
          pkg:
          pkg.overrideAttrs (attrs: {
            postInstall = attrs.postInstall or "" + ''
              touch "$out/oAs-second"
            '';
          })
        )
      ];
    in
    runTest "php-test-unwrapped-overrideAttrs-stacks" ''
      checking "if first override remained"
      ${check (builtins.match ".*oAs-first.*" customPhp.postInstall != null)}

      checking "if second override is there"
      ${check (builtins.match ".*oAs-second.*" customPhp.postInstall != null)}
    '';

  # Regression test for https://github.com/NixOS/nixpkgs/issues/509863:
  # wrapping php's stdenv with an adapter that uses `extendMkDerivationArgs`
  # (e.g. `keepDebugInfo`) used to trigger an infinite recursion via the
  # custom `passthru.overrideAttrs` defined for unwrapped php. Forcing the
  # derivation here would stack-overflow before the fix; checking
  # `dontStrip` also confirms the adapter actually applied.
  stdenvAdapter-keepDebugInfo-does-not-recurse =
    let
      customPhp = php.override {
        stdenv = stdenvAdapters.keepDebugInfo stdenv;
      };
    in
    runTest "php-test-stdenvAdapter-keepDebugInfo-does-not-recurse" ''
      checking "if the override evaluates without infinite recursion"
      ${check (builtins.isString customPhp.unwrapped.drvPath)}

      checking "if keepDebugInfo's dontStrip propagated to the unwrapped derivation"
      ${check (customPhp.unwrapped.dontStrip or false)}
    '';

  wrapped-overrideAttrs-stacks =
    let
      customPhp = lib.pipe php [
        (
          pkg:
          pkg.overrideAttrs (attrs: {
            postInstall = attrs.postInstall or "" + ''
              touch "$out/oAs-first"
            '';
          })
        )

        (
          pkg:
          pkg.overrideAttrs (attrs: {
            postInstall = attrs.postInstall or "" + ''
              touch "$out/oAs-second"
            '';
          })
        )
      ];
    in
    runTest "php-test-wrapped-overrideAttrs-stacks" ''
      checking "if first override remained"
      ${check (builtins.match ".*oAs-first.*" customPhp.unwrapped.postInstall != null)}

      checking "if second override is there"
      ${check (builtins.match ".*oAs-second.*" customPhp.unwrapped.postInstall != null)}
    '';
}
