{ stdenv
, lib
, fetchzip
}:

let
  os = if stdenv.isDarwin then "macos" else "linux";
  arch = if stdenv.isAarch64 then "aarch64" else "x86_64";
  platform = "${os}-${arch}";
in
stdenv.mkDerivation rec {
  pname = "urbit";
  version = "2.0";

  src = fetchzip {
    url = "https://github.com/urbit/vere/releases/download/vere-v${version}/${platform}.tgz";
    sha256 = {
      x86_64-linux = "sha256-GqxgbJCLjXcXHT49fJL1IUJmh9oL4Lfokt7HqzshtWw=";
      aarch64-linux = "sha256-3+S5EnyvTBKxkFbV7fg+qVDFLr25jMeDwb+MuqDJHMg=";
      x86_64-darwin = "sha256-VO2dnNqbgyPKvZVMC0CG15JAaBelzcnkifmbZMS+38Y=";
      aarch64-darwin = "sha256-RbpeIA5LYCUkhyLMo3dYvUe7uLyOD4Ey7qCvIg5JQAg=";
    }.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
  };

  postInstall = ''
    install -m755 -D vere-v${version}-${platform} $out/bin/urbit
  '';

  passthru.updateScript = ./update-bin.sh;

  meta = with lib; {
    homepage = "https://urbit.org";
    description = "An operating function";
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    maintainers = [ maintainers.matthew-levan ];
    license = licenses.mit;
  };
}
