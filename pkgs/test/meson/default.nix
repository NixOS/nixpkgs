{
  lib,
  stdenv,
  buildPackages,
  writeText,
}:
let
  inherit (lib.systems) elaborate;
  native = stdenv.buildPlatform.system;
  platforms = build: host: target: {
    # Elaborate independently to exercise equality without object identity.
    buildPlatform = elaborate build;
    hostPlatform = elaborate host;
    targetPlatform = elaborate target;
  };
  # The five equality partitions of BUILD, HOST and TARGET.
  compilerPlatforms = platforms native native (
    if native == "riscv64-linux" then "x86_64-linux" else "riscv64-linux"
  );
  cases = {
    native = platforms native native native;
    cross = platforms "x86_64-linux" "aarch64-linux" "aarch64-linux";
    compiler = compilerPlatforms;
    nativeTool = compilerPlatforms;
    canadian = platforms "x86_64-linux" "aarch64-linux" "riscv64-linux";
    targetIsBuild = platforms "x86_64-linux" "aarch64-linux" "x86_64-linux";
  };
  check =
    name: platforms:
    let
      inherit (platforms) hostPlatform;
      nativeTool = name == "nativeTool";
      targetPlatform = if nativeTool then hostPlatform else platforms.targetPlatform;
      flags =
        (import ../../build-support/lib/meson.nix {
          inherit lib;
          stdenv = platforms;
        }).makeMesonFlags
          {
            configurePlatforms = lib.optionals (!nativeTool) [ "target" ];
          };
      project = writeText "meson.build" ''
        project('machine-roles', ${lib.optionalString (name == "compiler") "'c',"} meson_version: '>=1.0')
        assert(host_machine.cpu() == '${hostPlatform.parsed.cpu.name}')
        assert(target_machine.cpu() == '${targetPlatform.parsed.cpu.name}')
        assert(meson.is_cross_build() == ${lib.boolToString (name != "native" && !nativeTool)})
        if meson.is_cross_build()
          assert(meson.get_external_property('bindgen_clang_arguments') == ['-target', '${hostPlatform.config}'])
        endif
        ${lib.optionalString (name == "compiler") ''
          # Distinct TARGET metadata must not retarget HOST compilation or execution.
          assert(meson.can_run_host_binaries())
          result = meson.get_compiler('c').run('int main(void) { return 0; }')
          assert(result.compiled() and result.returncode() == 0)
        ''}
      '';
    in
    ''
      mkdir ${name}
      cp ${project} ${name}/meson.build
      meson setup --backend=none ${name}-build ${name} ${lib.escapeShellArgs flags}
    '';
in
buildPackages.runCommandCC "meson-machine-roles"
  {
    nativeBuildInputs = [ buildPackages.meson ];
  }
  ''
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList check cases)}
    touch "$out"
  ''
