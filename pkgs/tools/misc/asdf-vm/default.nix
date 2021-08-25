{ stdenv, lib, fetchFromGitHub, makeWrapper, installShellFiles, bash, coreutils, curl, git, writeScript }:

let
  asdfReshimFile = writeScript "asdf-reshim" ''
#!/usr/bin/env bash

# asdf-vm create "shim" file like this:
#
#    exec $ASDF_DIR/bin/asdf exec "node" "$@"
#
# So we should reshim all installed versions every time shell initialized,
# because $out always change

asdfDir="''${ASDF_DIR:-$HOME/.asdf}"
asdfDataDir="''${ASDF_DATA_DIR:-$HOME/.asdf}"

prevAsdfDirFilePath="$asdfDataDir/.nix-prev-asdf-dir-path"

if [ -r "$prevAsdfDirFilePath" ]; then
  prevAsdfDir="$(cat "$prevAsdfDirFilePath")"
else
  prevAsdfDir=""
fi

if [ "$prevAsdfDir" != "$asdfDir" ]; then
  rm -rf "$asdfDataDir"/shims
  "$asdfDir"/bin/asdf reshim
  echo "$asdfDir" > "$prevAsdfDirFilePath"
fi
  '';

  asdfPrepareFile = writeScript "asdf-prepare" ''
ASDF_DIR="@asdfDir@"

source "$ASDF_DIR/asdf.sh"
${asdfReshimFile}
  '';
in stdenv.mkDerivation rec {
  pname = "asdf-vm";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "asdf-vm";
    repo = "asdf";
    rev = "v${version}";
    sha256 = "07lh5k1krzm7fbkv0jlwbzz5ycn2jg7s12dnqwmy82qqic0sl6fl";
  };

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  buildInputs = [
    bash
    curl
    git
  ];

  installPhase = ''
    mkdir -p $out/share/asdf-vm
    cp -r . $out/share/asdf-vm

    mkdir -p $out/etc/profile.d
    substitute ${asdfPrepareFile} $out/etc/profile.d/asdf-prepare.sh \
      --replace "@asdfDir@" "$out/share/asdf-vm"

    mkdir -p $out/bin
    makeWrapper $out/share/asdf-vm/bin/asdf $out/bin/asdf \
      --set ASDF_DIR $out/share/asdf-vm

    installShellCompletion --cmd asdf \
      --zsh completions/_asdf \
      --fish completions/asdf.fish \
      --bash completions/asdf.bash
  '';

  meta = with lib; {
    description = "Extendable version manager with support for Ruby, Node.js, Erlang & more";
    homepage = "https://asdf-vm.com/";
    license = licenses.mit;
    maintainers = [ maintainers.c4605 ];
    platforms = platforms.unix;
  };
}
