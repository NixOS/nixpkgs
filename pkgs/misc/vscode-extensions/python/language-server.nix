{ fetchurl, extractNuGet, arch }:
let

  languageServerSha256 = {
    linux-x64 = "1w3y0sn6ijk1vspi4lailg1q1iy9lwslhx92c7jbrrkiaszvaqwn";
    osx-x64 = "11l4fic8cvgh1l3dq6qxi51pwhcic79zf13rhyajl5w5g13caafp";
  }.${arch};
in
  # version is languageServerVersion in the package.json
  extractNuGet rec {
    name = "Python-Language-Server";
    version = "0.4.24";

    src = fetchurl {
      url = "https://pvsc.azureedge.net/python-language-server-stable/${name}-${arch}.${version}.nupkg";
      sha256 = languageServerSha256;
    };

    preInstall = ''
      patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" Microsoft.Python.LanguageServer
    '';
  }

