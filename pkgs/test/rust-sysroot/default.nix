{ lib, rust, rustPlatform, fetchFromGitHub }:

let
  mkBlogOsTest = target: rustPlatform.buildRustPackage rec {
    name = "rust-sysroot-test";

    src = ./nostd;
    cargoLock.lockFile = ./nostd/Cargo.lock;

    # TODO: workaround for rust hooks not supporting --target customization
    buildPhase = ''
      cargo build --release --frozen --target $target
    '';
    installPhase = "touch $out";

    doCheck = false;

    inherit target;

    meta = with lib; {
        description = "Test for using custom sysroots with buildRustPackage";
        maintainers = with maintainers; [ aaronjanse ];
        platforms = lib.platforms.x86_64;
    };
  };

  targetContents = {
    "llvm-target" = "x86_64-unknown-none";
    "data-layout" = "e-m:e-i64:64-f80:128-n8:16:32:64-S128";
    "arch" = "x86_64";
    "target-endian" = "little";
    "target-pointer-width" = "64";
    "target-c-int-width" = "32";
    "os" = "none";
    "executables" = true;
    "linker-flavor" = "gcc";
    "panic-strategy" = "abort";
    "disable-redzone" = true;
    "features" = "-mmx,-sse,+soft-float";
  };

in lib.recurseIntoAttrs {
  targetByFile = mkBlogOsTest (builtins.toFile "x86_64-blog_os.json" (builtins.toJSON targetContents));
  targetByNix = let
    plat = lib.systems.elaborate { config = "x86_64-none"; } // {
      rustc = {
        config = "x86_64-blog_os";
        platform = targetContents;
      };
    };
    in mkBlogOsTest (rust.toRustTargetSpec plat);
}
