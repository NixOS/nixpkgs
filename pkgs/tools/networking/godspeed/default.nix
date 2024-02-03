{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "godspeed";
  version = "unstable-2021-08-27";

  src = fetchFromGitHub {
    owner = "redcode-labs";
    repo = "GodSpeed";
    rev = "c02b184ab0fd304d1bd8cbe1566a3d3de727975e";
    sha256 = "sha256-y/mCfNWe5ShdxEz8IUQ8zUzgVkUy/+5lX6rcJ3r6KoI=";
  };

  vendorHash = "sha256-DCDAuKvov4tkf77nJNo9mQU/bAeQasp4VBQRtLX+U6c=";

  buildInputs = [
    libpcap
  ];

  postFixup = ''
    mv $out/bin/GodSpeed $out/bin/${pname}
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Manager for reverse shells";
    homepage = "https://github.com/redcode-labs/GodSpeed";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ] ++ teams.redcodelabs.members;
  };
}
