{ lib
, buildNpmPackage
, nodePackages
, fetchFromGitHub
, runtimeShell
}:

# We just package the JS frontend part, not the Python reverse-proxy backend.
# NixOS can provide any another reverse proxy such as nginx.
buildNpmPackage rec {
  pname = "ollama-webui";
  # ollama-webui doesn't tag versions yet.
  version = "0.0.0-unstable-2023-12-22";

  src = fetchFromGitHub {
    owner = "ollama-webui";
    repo = "ollama-webui";
    rev = "77c1a77fccb04337ff95440030cd051fd16c2cd8";
    hash = "sha256-u7h2tpHgtQwYXornslY3CZjKjigqBK2mHmaiK1EoEgk=";
  };
  # dependencies are downloaded into a separate node_modules Nix package
  npmDepsHash = "sha256-SI2dPn1SwbGwl8093VBtcDsA2eHSxr3UUC+ta68w2t8=";

  # We have to bake in the default URL it will use for ollama webserver here,
  # but it can be overriden in the UI later.
  PUBLIC_API_BASE_URL = "http://localhost:11434/api";

  # The path '/ollama/api' will be redirected to the specified backend URL
  OLLAMA_API_BASE_URL = PUBLIC_API_BASE_URL;
  # "npm run build" creates a static page in the "build" folder.
  installPhase = ''
    mkdir -p $out/lib
    cp -R ./build/. $out/lib

    mkdir -p $out/bin
    cat <<EOF >>$out/bin/${pname}
    #!${runtimeShell}
    ${nodePackages.http-server}/bin/http-server $out/lib
    EOF
    chmod +x $out/bin/${pname}
  '';

  meta = with lib; {
    description = "ChatGPT-Style Web Interface for Ollama";
    longDescription = ''
      Tools like Ollama make open-source large langue models (LLM) accessible and almost
      trivial to download and run them locally on a consumer computer.
      However, Ollama only runs in a terminal and doesn't store any chat history.
      Ollama-WebUI is a web frontend on top of Ollama that looks and behaves similar to ChatGPT's web frontend.
      You can have separate chats with different LLMs that are saved in your browser,
      automatic Markdown and Latex rendering, upload files etc.
      This package contains two parts:
      - `<nix-store-package-path>/lib` The WebUI as a compiled, static html folder to bundle in your web server
      - `<nix-store-package-path>/bin/${pname}` A runnable webserver the serves the WebUI for convenience.
    '';
    homepage = "https://github.com/ollama-webui/ollama-webui";
    license = licenses.mit;
    mainProgram = pname;
    maintainers = with maintainers; [ malteneuss ];
    platforms = platforms.all;
  };
}
