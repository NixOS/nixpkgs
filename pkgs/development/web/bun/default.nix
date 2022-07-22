{ stdenvNoCC, callPackage, fetchurl, autoPatchelfHook, unzip, openssl, lib }:
let
  dists = {
    aarch64-darwin = {
      arch = "aarch64";
      shortName = "darwin";
      sha256 = "1gfqd13nvzaw74czgn8zn3igg9ya89ddmwj3qslzgc71i3zv66sq";
    };

    x86_64-darwin = {
      arch = "x64";
      shortName = "darwin";
      sha256 = "0pxcy1g83rdqpkips2s0j8vynd7y7bw78bq9qdhx8dkvxa1sj2br";
    };

    x86_64-linux = {
      arch = "x64";
      shortName = "linux";
      sha256 = "1rmy5xy5sf5gqgggg1fyxyhywlf1nw745fhblvxy0xdqd6zis3xq";
    };
  };
  dist = dists.${stdenvNoCC.hostPlatform.system} or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation rec {
  version = "0.1.4";
  pname = "bun";

  src = fetchurl {
    url = "https://github.com/Jarred-Sumner/bun-releases-for-updater/releases/download/bun-v${version}/bun-${dist.shortName}-${dist.arch}.zip";
    sha256 = dist.sha256;
  };

  strictDeps = true;
  nativeBuildInputs = [ unzip ] ++ lib.optionals stdenvNoCC.isLinux [ autoPatchelfHook ];
  buildInputs = [ openssl ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm 755 ./bun $out/bin/bun
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://bun.sh";
    changelog = "https://github.com/Jarred-Sumner/bun/releases/tag/bun-v${version}";
    description = "Incredibly fast JavaScript runtime, bundler, transpiler and package manager – all in one";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    longDescription = ''
      All in one fast & easy-to-use tool. Instead of 1,000 node_modules for development, you only need bun.
    '';
    license = with licenses; [
      mit # bun core
      lgpl21Only # javascriptcore and webkit
    ];
    maintainers = with maintainers; [ DAlperin jk ];
    platforms = builtins.attrNames dists;
  };
}
