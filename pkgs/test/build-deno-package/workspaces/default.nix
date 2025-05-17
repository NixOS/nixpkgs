{ pkgs, buildDenoPackage }:
rec {
  sub1 = buildDenoPackage {
    pname = "test-deno-build-workspaces-sub1";
    version = "0.1.0";
    denoDepsHash = "sha256-Qvn3g+2NeWpNCfmfqXtPcJU4+LwrOSh1nq51xAbZZhk=";
    src = pkgs.nix-gitignore.gitignoreSource [ ] ./.;
    denoWorkspacePath = "./sub1";
    denoTaskFlags = [
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
    denoTaskFlags = [
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
  };
}
