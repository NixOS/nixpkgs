{ stdenv, fetchFromGitHub, rustPlatform, darwin, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "bottom";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "ClementTsang";
    repo = pname;
    rev = version;
    sha256 = "sha256-88uEEsb+coX8PTKrem+0t5AkamCmqJsFYsENFTZSsys=";
  };

  prePatch = ''
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = stdenv.lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.IOKit;

  cargoSha256 = "sha256-qnh4Tl6JRgxBJbu+t9IJX/XChIR15rTRLvsl+/ZvPxY=";

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
