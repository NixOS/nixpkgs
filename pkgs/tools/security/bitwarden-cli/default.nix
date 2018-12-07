{ stdenv, fetchFromGitHub, nodejs }:

stdenv.mkDerivation rec {
  name = "bitwarden-cli-${version}";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "cli";
    rev = "v${version}";
    fetchSubmodules = true; 
    sha256 = "1csdbv692l69lickzzl8246gvl0gi58hc91aja3xmb1kcxiphc7c";
  };

  buildInputs = [ nodejs ];
  buildCommand = ''
    unpackPhase
    cd "$sourceRoot"
    export HOME="."

    npm install
    npm run dist:lin

    mkdir -p "$out/bin"
    cp "./dist/linux/bw" "$out/bin/bw"
  '';

  meta = with stdenv.lib; {
    description = "Bitwarden Command-line Interface";
    longDescription = ''
      The Bitwarden CLI is a powerful, full-featured command-line interface (CLI) tool to access and manage a Bitwarden vault. The CLI is written with TypeScript and Node.js and can be run on Windows, macOS, and Linux distributions.
    '';
    homepage = "https://bitwarden.com/";
    license = licenses.gpl3;
    maintainers = [ maintainers.wolfereign ];
    platforms = [ "x86_64-linux" ];
  };
}