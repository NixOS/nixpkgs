{ lib, rustPlatform, fetchCrate, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "cauwugo";
  version = "0.1.0";

  src = fetchCrate {
    inherit version;
    pname = "bpaf_cauwugo";
    sha256 = "sha256-9gWUu2qbscKlbWZlRbOn+rrmizegkHxPnwnAmpaV1Ww=";
  };

  cargoSha256 = "sha256-dXlSBb3ey3dAiifrQ9Bbhscnm1QmcChiQbX1ic069V4=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd cauwugo \
      --bash <($out/bin/cauwugo --bpaf-complete-style-bash) \
      --fish <($out/bin/cauwugo --bpaf-complete-style-fish) \
      --zsh  <($out/bin/cauwugo --bpaf-complete-style-zsh)
  '';

  meta = with lib; {
    description = "An alternative cargo frontend that implements dynamic shell completion for usual cargo commands";
    homepage = "https://github.com/pacak/bpaf/tree/master/bpaf_cauwugo";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
