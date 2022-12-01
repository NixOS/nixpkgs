{ stdenv, lib, fetchFromGitHub, buildGoModule, libnotify, pcsclite, pkg-config, darwin }:

buildGoModule rec {
  pname = "yubikey-agent";

  version = "unstable-2022-03-17";
  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "yubikey-agent";
    rev = "205a7ef2554625c7494038600d963123d6311873";
    sha256 = "sha256-wJpN63KY5scmez6yYFsIr3JLEUB+YSl/XvoatIIeRI0=";
  };

  buildInputs =
    lib.optional stdenv.isLinux (lib.getDev pcsclite)
    ++ lib.optional stdenv.isDarwin (darwin.apple_sdk.frameworks.PCSC);

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace main.go --replace 'notify-send' ${libnotify}/bin/notify-send
  '';

  vendorSha256 = "sha256-SnjbkDPVjAnCbM2nLqBsuaPZwOmvDTKiUbi/93BlWVQ=";

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

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
