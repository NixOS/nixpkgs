{ lib
, buildGoModule
, fetchFromGitHub
, makeBinaryWrapper
}:

buildGoModule {
  pname = "icebreaker";
  version = "unstable-2023-08-13";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "icebreaker";
    rev = "71fe0679fcf82ccf458b47585cda09f3ef213155";
    hash = "sha256-d8x4Q4ZT0qrKWEIRbYVOUjhnkJWOgY0ct/+cjaSh7SU=";
  };

  proxyVendor = true;
  vendorHash = "sha256-i648w+BOUX5IfEEZ11gJAjX1ZUdoYRzDPz6GDe7i2S8=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    mkdir -p $out/share
    cp -r static templates $out/share

    wrapProgram $out/bin/icebreaker \
      --chdir $out/share \
      --set-default GIN_MODE release
  '';

  meta = with lib; {
    description = "Web app that allows students to ask real-time, anonymous questions during class";
    homepage = "https://github.com/jonhoo/icebreaker";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "icebreaker";
  };
}
