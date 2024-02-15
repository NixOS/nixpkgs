{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, clang
, pkg-config
, elfutils
, rustfmt
, zlib
}:

rustPlatform.buildRustPackage rec {
  pname = "below";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "below";
    rev = "v${version}";
    sha256 = "sha256-2mZBpvLPY6yrEAvB1YlFuaXJlmmNuZqhu3xWADNHbx0=";
  };

  cargoHash = "sha256-cTNxWCd4YH5VuZh0GRfBNtHmLqCQ75uyHqROkv1jbRA=";

  prePatch = ''sed -i "s,ExecStart=.*/bin,ExecStart=$out/bin," etc/below.service'';
  postInstall = ''
    install -d $out/lib/systemd/system
    install -t $out/lib/systemd/system etc/below.service
  '';

  # bpf code compilation
  hardeningDisable = [ "stackprotector" ];

  nativeBuildInputs = [ clang pkg-config rustfmt ];
  buildInputs = [ elfutils zlib ];

  # needs /sys/fs/cgroup
  doCheck = false;

  meta = with lib; {
    platforms = platforms.linux;
    maintainers = with maintainers; [ globin ];
    description = "A time traveling resource monitor for modern Linux systems";
    license = licenses.asl20;
    homepage = "https://github.com/facebookincubator/below";
    mainProgram = "below";
  };
}
