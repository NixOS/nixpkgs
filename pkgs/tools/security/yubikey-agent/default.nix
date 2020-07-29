{ stdenv, lib, fetchFromGitHub, buildGoModule, libnotify, makeWrapper, pcsclite, pinentry_mac, pkgconfig, darwin }:

buildGoModule rec {
  pname = "yubikey-agent";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "07gix5wrakn4z846zhvl66lzwx58djrfnn6m8v7vc69l9jr3kihr";
  };

  buildInputs =
    lib.optional stdenv.isLinux (lib.getDev pcsclite)
    ++ lib.optional stdenv.isDarwin (darwin.apple_sdk.frameworks.PCSC);

  nativeBuildInputs = [ makeWrapper pkgconfig ];

  # pull in go-piv/piv-go#75
  # once go-piv/piv-go#75 is merged and released, we should
  # use the released version (and push upstream to do the same)
  patches = [ ./use-piv-go-75.patch ];
  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace main.go --replace 'notify-send' ${libnotify}/bin/notify-send
  '';

  vendorSha256 = "128mlsagj3im6h0p0ndhzk29ya47g19im9dldx3nmddf2jlccj2h";

  subPackages = [ "." ];

  # On macOS, there isn't a choice of pinentry program, so let's
  # ensure the nixpkgs-provided one is available
  postInstall = lib.optionalString stdenv.isDarwin ''
    wrapProgram $out/bin/yubikey-agent --suffix PATH : $(dirname ${pinentry_mac}/${pinentry_mac.binaryPath})
  ''
  # Note: in the next release, upstream provides
  # contrib/systemd/user/yubikey-agent.service, which we should use
  # instead
  # See https://github.com/FiloSottile/yubikey-agent/pull/43
  + lib.optionalString stdenv.isLinux ''
    mkdir -p $out/lib/systemd/user
    substitute ${./yubikey-agent.service} $out/lib/systemd/user/yubikey-agent.service \
      --replace 'ExecStart=yubikey-agent' "ExecStart=$out/bin/yubikey-agent"
  '';

  meta = with lib; {
    description = "A seamless ssh-agent for YubiKeys";
    license = licenses.bsd3;
    homepage = "https://filippo.io/yubikey-agent";
    maintainers = with lib.maintainers; [ philandstuff rawkode ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
