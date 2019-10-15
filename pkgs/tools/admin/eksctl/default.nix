{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "eksctl";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = pname;
    rev = version;
    sha256 = "0gh6p912y8i295p3vwhlrsxky761zlvrykcl6jm6j2qhwl5k4k29";
  };

  modSha256 = "0c8hbb73w1922qh895lsk0m9i7lk9kzrvxjc4crwsfpn9pv0qgd3";

  subPackages = [ "cmd/eksctl" ];

  buildFlags = [ "-tags netgo" "-tags release" ];

  postInstall =
  ''
    mkdir -p "$out/share/"{bash-completion/completions,zsh/site-functions}

    $out/bin/eksctl completion bash > "$out/share/bash-completion/completions/eksctl"
    $out/bin/eksctl completion zsh > "$out/share/zsh/site-functions/_eksctl"
  '';

  meta = with lib; {
    description = "A CLI for Amazon EKS";
    homepage = "https://github.com/weaveworks/eksctl";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ xrelkd ];
  };
}
