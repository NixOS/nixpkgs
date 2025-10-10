{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper
, ripgrep
}:

#
# Nix derivation for the Factory AI "Droid" CLI.
#
# This package wraps the pre‑built droid binary distributed by Factory.
# Upstream distributes separate binaries for each supported operating system
# and CPU architecture.  We select the correct URL and SHA256 hash based on
# the build host’s platform.  The binary is not open source and is
# distributed under a proprietary licence, so the package is marked as
# unfree.
#
# NOTE: The upstream download site currently requires authentication and
# returns HTTP 403 when accessed anonymously.  The sha256 values below
# have been pre-fetched from the public .sha256 files.

let
  pname = "droid";
  version = "0.19.5";

  # Map each supported platform to its download URL and hash.  Use
  # stdenv.hostPlatform.system to select the right entry at evaluation time.
  sources = rec {
    "x86_64-linux" = {
      url = "https://downloads.factory.ai/factory-cli/releases/${version}/linux/x64/${pname}";
      sha256 = "1xz6j6x7dymw75mgl4ygi89jsnrglncd26c664nfcs8ajr16n53k";
    };
    "aarch64-linux" = {
      url = "https://downloads.factory.ai/factory-cli/releases/${version}/linux/arm64/${pname}";
      sha256 = "1cbzdkp676wksqammhxhdspl4mbik3r3fnjmjfqvqddad0nmxq31";
    };
    "x86_64-darwin" = {
      url = "https://downloads.factory.ai/factory-cli/releases/${version}/darwin/x64/${pname}";
      sha256 = "0a0jwg6dakwswfax9w690r0cwhdmhqzdngghalc09h9z7vdqw500";
    };
    "aarch64-darwin" = {
      url = "https://downloads.factory.ai/factory-cli/releases/${version}/darwin/arm64/${pname}";
      sha256 = "0y53lmdyyz89nncw0f0h17b47aldsi4k2sr16ixyybj49wf0q3my";
    };
  };

  # Choose the appropriate source for the host platform.  If the platform
  # isn’t supported, throw an error so the build fails cleanly.
  srcInfo = sources.${stdenv.hostPlatform.system} or (throw "Unsupported platform for droid: ${stdenv.hostPlatform.system}");
in

stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchurl {
    name = "${pname}-${version}-${stdenv.hostPlatform.system}";
    inherit (srcInfo) url sha256;
  };

  # Don’t unpack: the source is a single executable file.
  dontUnpack = true;

  # autoPatchelfHook is only needed on Linux to fix the RPATH of the binary.
  # makeWrapper is needed for the postFixup phase on all platforms.
  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ ripgrep ];

  dontStrip = true;
  installPhase = ''
    runHook preInstall
    install -D -m755 $src $out/bin/${pname}
    runHook postInstall
  '';

  # Wrap the binary so it can find ripgrep on PATH.  Upstream’s
  # installation script downloads ripgrep into a private directory; here we
  # reuse the nixpkgs ripgrep package instead.
  postFixup = ''
    wrapProgram $out/bin/${pname} \
      --prefix PATH : ${ripgrep}/bin
  '';

  meta = with lib; {
    description = "Factory Droid CLI – AI‑powered development assistant";
    homepage    = "https://factory.ai";
    license     = licenses.unfree; # proprietary licence, upstream does not provide source
    maintainers = with maintainers; [ SkrOYC ];
    # Mark this package as unfree so that users must explicitly allow it.
    platforms   = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}