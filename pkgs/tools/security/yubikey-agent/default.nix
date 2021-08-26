{ stdenv, lib, fetchFromGitHub, buildGoModule, libnotify, makeWrapper, pcsclite, pkg-config, darwin }:

buildGoModule rec {
  pname = "yubikey-agent";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "14s61jgcmpqh70jz0krrai8xg0xqhwmillxkij50vbsagpxjssk6";
  };

  buildInputs =
    lib.optional stdenv.isLinux (lib.getDev pcsclite)
    ++ lib.optional stdenv.isDarwin (darwin.apple_sdk.frameworks.PCSC);

  nativeBuildInputs = [ makeWrapper pkg-config ];

  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace main.go --replace 'notify-send' ${libnotify}/bin/notify-send
  '';

  vendorSha256 = "0cpj4nj2g0ick6p79h4pnjg7ybnyz9p26jivv0awi6bmn378nbxn";

  doCheck = false;

  subPackages = [ "." ];

  postInstall = lib.optionalString stdenv.isLinux ''
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
