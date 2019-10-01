{ gcc-unwrapped, curl, fetchurl, extractNuGet, arch, autoPatchelfHook, unzip
, lttng-ust
}:
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

    buildInputs = [ autoPatchelfHook curl unzip gcc-unwrapped.lib lttng-ust ];
    src = fetchurl {
      url = "https://pvsc.azureedge.net/python-language-server-stable/${name}-${arch}.${version}.nupkg";
      sha256 = languageServerSha256;
    };

  }

