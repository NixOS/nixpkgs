{ lib, pkgs, stdenvNoCC }:

let
  tests =
    let
      p = pkgs.python3Packages.xpybutil.overridePythonAttrs (_: { dontWrapPythonPrograms = true; });
    in
    {
      overridePythonAttrs = {
        expr = !lib.hasInfix "wrapPythonPrograms" p.postFixup;
        expected = true;
      };
      repeatedOverrides-pname = {
        expr = repeatedOverrides.pname == "a-better-hello-with-blackjack";
        expected = true;
      };
      repeatedOverrides-entangled-pname = {
        expr = repeatedOverrides.entangled.pname == "a-better-figlet-with-blackjack";
        expected = true;
      };
      overriding-using-only-attrset = {
        expr = (pkgs.hello.overrideAttrs { pname = "hello-overriden"; }).pname == "hello-overriden";
        expected = true;
      };
      overriding-using-only-attrset-no-final-attrs = {
        name = "overriding-using-only-attrset-no-final-attrs";
        expr = ((stdenvNoCC.mkDerivation { pname = "hello-no-final-attrs"; }).overrideAttrs { pname = "hello-no-final-attrs-overridden"; }).pname == "hello-no-final-attrs-overridden";
        expected = true;
      };
      buildGoModule-overrideAttrs = {
        expr = lib.all (
          attrPath:
          let
            attrPathPretty = lib.concatStringsSep "." attrPath;
            valueNative = lib.getAttrFromPath attrPath pet_0_4_0;
            valueOverridden = lib.getAttrFromPath attrPath pet_0_4_0-overridden;
          in
          lib.warnIfNot
            (valueNative == valueOverridden)
            "pet_0_4_0.${attrPathPretty} (${valueNative}) does not equal pet_0_4_0-overridden.${attrPathPretty} (${valueOverridden})"
            true
        ) [
          [ "drvPath" ]
          [ "name" ]
          [ "pname" ]
          [ "version" ]
          [ "vendorHash" ]
          [ "goModules" "drvPath" ]
          [ "goModules" "name" ]
          [ "goModules" "outputHash" ]
        ];
        expected = true;
      };
      buildGoModule-goModules-overrideAttrs = {
        expr = pet-foo.goModules.FOO == "foo";
        expected = true;
      };
      buildGoModule-goModules-overrideAttrs-vendored = {
        expr = lib.isString pet-vendored.drvPath;
        expected = true;
      };
    };

  addEntangled = origOverrideAttrs: f:
    origOverrideAttrs (
      lib.composeExtensions f (self: super: {
        passthru = super.passthru // {
          entangled = super.passthru.entangled.overrideAttrs f;
          overrideAttrs = addEntangled self.overrideAttrs;
        };
      })
    );

  entangle = pkg1: pkg2: pkg1.overrideAttrs (self: super: {
    passthru = super.passthru // {
      entangled = pkg2;
      overrideAttrs = addEntangled self.overrideAttrs;
    };
  });

  example = entangle pkgs.hello pkgs.figlet;

  overrides1 = example.overrideAttrs (_: super: { pname = "a-better-${super.pname}"; });

  repeatedOverrides = overrides1.overrideAttrs (_: super: { pname = "${super.pname}-with-blackjack"; });

  pet_0_3_4 = pkgs.buildGoModule rec {
    pname = "pet";
    version = "0.3.4";

    src = pkgs.fetchFromGitHub {
      owner = "knqyf263";
      repo = "pet";
      rev = "v${version}";
      hash = "sha256-Gjw1dRrgM8D3G7v6WIM2+50r4HmTXvx0Xxme2fH9TlQ=";
    };

    vendorHash = "sha256-ciBIR+a1oaYH+H1PcC8cD8ncfJczk1IiJ8iYNM+R6aA=";

    meta = {
      description = "Simple command-line snippet manager, written in Go";
      homepage = "https://github.com/knqyf263/pet";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ kalbasit ];
    };
  };

  pet_0_4_0 = pkgs.buildGoModule rec {
    pname = "pet";
    version = "0.4.0";

    src = pkgs.fetchFromGitHub {
      owner = "knqyf263";
      repo = "pet";
      rev = "v${version}";
      hash = "sha256-gVTpzmXekQxGMucDKskGi+e+34nJwwsXwvQTjRO6Gdg=";
    };

    vendorHash = "sha256-dUvp7FEW09V0xMuhewPGw3TuAic/sD7xyXEYviZ2Ivs=";

    meta = {
      description = "Simple command-line snippet manager, written in Go";
      homepage = "https://github.com/knqyf263/pet";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ kalbasit ];
    };
  };

  pet_0_4_0-overridden = pet_0_3_4.overrideAttrs (finalAttrs: previousAttrs: {
  version = "0.4.0";

  src = pkgs.fetchFromGitHub {
    inherit (previousAttrs.src) owner repo;
    rev = "v${finalAttrs.version}";
    hash = "sha256-gVTpzmXekQxGMucDKskGi+e+34nJwwsXwvQTjRO6Gdg=";
  };

  vendorHash = "sha256-dUvp7FEW09V0xMuhewPGw3TuAic/sD7xyXEYviZ2Ivs=";
  });

  pet-foo = pet_0_3_4.overrideAttrs (
    finalAttrs: previousAttrs: {
      passthru = previousAttrs.passthru // {
        overrideModAttrs = lib.composeExtensions previousAttrs.passthru.overrideModAttrs (
          finalModAttrs: previousModAttrs: {
            FOO = "foo";
          }
        );
      };
    }
  );

  pet-vendored = pet-foo.overrideAttrs { vendorHash = null; };
in

stdenvNoCC.mkDerivation {
  name = "test-overriding";
  passthru = { inherit tests; };
  buildCommand = ''
    touch $out
  '' + lib.concatStringsSep "\n" (lib.attrValues (lib.mapAttrs (name: t: "([[ ${lib.boolToString t.expr} == ${lib.boolToString t.expected} ]] && echo '${name} success') || (echo '${name} fail' && exit 1)") tests));
}
