{ nix-gitignore, buildDenoPackage }:
rec {
  sub1 = buildDenoPackage {
    pname = "test-deno-build-workspaces-sub1";
    version = "0.1.0";
    denoDepsHash = "sha256-/Ye62fygYPHwoB663YcXTywdl51ZIZpPqF8GiFB7/A0=";
    src = nix-gitignore.gitignoreSource [ ] ./.;
    denoWorkspacePath = "./sub1";
    extraTaskFlags = [
      "--text"
      "sub1"
    ];
    denoTaskSuffix = ">out.txt";

    installPhase = ''
      cp out.txt $out
    '';
  };
  sub2 = buildDenoPackage {
    pname = "test-deno-build-workspaces-sub2";
    version = "0.1.0";
    inherit (sub1) denoDeps src;
    denoWorkspacePath = "./sub2";
    extraTaskFlags = [
      "--text"
      "sub2"
    ];
    denoTaskSuffix = ">out.txt";
    installPhase = ''
      cp out.txt $out
    '';
  };
  sub1Binary = buildDenoPackage {
    pname = "test-deno-build-workspaces-sub1-binary";
    version = "0.1.0";
    inherit (sub1) denoDeps src;
    denoWorkspacePath = "./sub1";
    binaryEntrypointPath = "./main.ts";
    denoCompileFlags = [ "--allow-import=unpkg.com:443,jsr.io:443,deno.land:443,esm.sh:443" ];
  };
}
