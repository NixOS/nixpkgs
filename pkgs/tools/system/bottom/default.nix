{ stdenv, fetchFromGitHub, rustPlatform, darwin, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "bottom";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "ClementTsang";
    repo = pname;
    rev = version;
    sha256 = "sha256-Gc2bL7KqDqab0hCCOi2rtEw+5r0bSETzTipLLdX/ipk=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = stdenv.lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.IOKit;

  cargoSha256 = "sha256-Bdkq3cTuziTQ7/BkvuBHbfuxRIXnz4h2OadoAGNTBc0=";

  doCheck = false;

  postInstall = ''
    installShellCompletion $releaseDir/build/bottom-*/out/btm.{bash,fish} --zsh $releaseDir/build/bottom-*/out/_btm
  '';

  meta = with stdenv.lib; {
    description = "A cross-platform graphical process/system monitor with a customizable interface";
    homepage = "https://github.com/ClementTsang/bottom";
    license = licenses.mit;
    maintainers = with maintainers; [ berbiche ];
    platforms = platforms.unix;
  };
}
