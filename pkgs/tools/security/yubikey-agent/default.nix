{ stdenv, lib, fetchFromGitHub, buildGoModule, libnotify, makeWrapper, pcsclite, pinentry_mac, pkg-config, darwin }:

buildGoModule rec {
  pname = "yubikey-agent";
  version = "unstable-2021-02-18";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = pname;
    rev = "8cadc13d107757f8084d9d2b93ea64ff0c1748e8";
    sha256 = "1lklgq9qkqil5s0g56wbhs0vpr9c1bd4ir7bkrjwqj75ygxim8ml";
  };

  buildInputs =
    lib.optional stdenv.isLinux (lib.getDev pcsclite)
    ++ lib.optional stdenv.isDarwin (darwin.apple_sdk.frameworks.PCSC);

  nativeBuildInputs = [ makeWrapper pkg-config ];

  # pull in go-piv/piv-go#75
  # once go-piv/piv-go#75 is merged and released, we should
  # use the released version (and push upstream to do the same)
  patches = [ ./use-piv-go-75.patch ];
  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace main.go --replace 'notify-send' ${libnotify}/bin/notify-send
  '';

  vendorSha256 = "1zx1w2is61471v4dlmr4wf714zqsc8sppik671p7s4fis5vccsca";

  doCheck = false;

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
    substitute contrib/systemd/user/yubikey-agent.service $out/lib/systemd/user/yubikey-agent.service \
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
