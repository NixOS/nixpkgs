{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, zlib
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "miniserve";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "miniserve";
    rev = "v${version}";
    sha256 = "sha256-5rFxVk+D11Iqr0SP2VYdMEnFwijpxQT8e5EoK2PYtmQ=";
  };

  cargoSha256 = "sha256-40TJzhaD1bi/u8k472K89A51wKhm/XjBs13W6oU/06Q=";

  nativeBuildInputs = [ installShellFiles pkg-config zlib ];
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  checkFlags = [
    "--skip=bind_ipv4_ipv6::case_2"
    "--skip=cant_navigate_up_the_root"
  ];

  postInstall = ''
    installShellCompletion --cmd miniserve \
      --bash <($out/bin/miniserve --print-completions bash) \
      --fish <($out/bin/miniserve --print-completions fish) \
      --zsh <($out/bin/miniserve --print-completions zsh)
  '';

  meta = with lib; {
    description = "For when you really just want to serve some files over HTTP right now!";
    homepage = "https://github.com/svenstaro/miniserve";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
