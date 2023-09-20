{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, fetchpatch
}:

buildGoModule rec {
  pname = "doggo";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "mr-karan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qc6RYz2bVaY/IBGIXUYO6wyh7iUDAJ1ASCK0dFwZo6s=";
  };

  patches = [
    # go 1.20 support
    # https://github.com/mr-karan/doggo/pull/66
    (fetchpatch {
      url = "https://github.com/mr-karan/doggo/commit/7db5c2144fa4a3f18afe1c724b9367b03f84aed7.patch";
      hash = "sha256-cx8s23e02zIvJOtuqTz8XC9ApYODh96Ubl1KhsFUZ9g=";
    })
  ];

  vendorHash = "sha256-GVLfPK1DFVSfNSdIxYSaspHFphd8ft2HUK0SMeWiVUg=";
  nativeBuildInputs = [ installShellFiles ];
  subPackages = [ "cmd/doggo" ];

  ldflags = [
    "-w -s"
    "-X main.buildVersion=v${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd doggo \
      --fish --name doggo.fish completions/doggo.fish \
      --zsh --name _doggo completions/doggo.zsh
  '';

  meta = with lib; {
    homepage = "https://github.com/mr-karan/doggo";
    description = "Command-line DNS Client for Humans. Written in Golang";
    longDescription = ''
      doggo is a modern command-line DNS client (like dig) written in Golang.
      It outputs information in a neat concise manner and supports protocols like DoH, DoT, DoQ, and DNSCrypt as well
    '';
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ georgesalkhouri ];
  };
}
