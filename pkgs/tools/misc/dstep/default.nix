{ lib, stdenv, fetchzip }:
stdenv.mkDerivation rec {
  name = "dstep";
  version = "1.0.0";

  src = passthru.sources.${stdenv.hostPlatform.system} or (throw
    "Unsupported system: ${stdenv.hostPlatform.system}");

  passthru = {
    sources = {
      x86_64-linux = fetchzip {
        url =
          "https://github.com/jacob-carlborg/dstep/releases/download/v${version}/dstep-${version}-linux-x86_64.tar.xz";
        hash = "sha256-7smk97r0bszP+3AfAO1YMge11dqtIn8F6qy1X0Y7LrU=";
      };
      x86_64-darwin = fetchzip {
        url =
          "https://github.com/jacob-carlborg/dstep/releases/download/v${version}/dstep-${version}-macos.tar.xz";
        hash = "sha256-ZYFmIKYgbejU23z+0agagzNJqfS0Q3P9oe9OA75GUQk=";
      };
    };
  };

  postInstall = ''
    mkdir -p $out/bin
    cp $src/dstep $out/bin
  '';

  meta = with lib; {
    description =
      "A tool for converting C and Objective-C headers to D modules";
    homepage = "https://github.com/jacob-carlborg/dstep";
    license = licenses.boost;
    mainProgram = "dstep";
    platforms = builtins.attrNames passthru.sources;
  };
}
