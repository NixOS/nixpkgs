{ lib
, stdenv
, fetchFromGitHub
, makeBinaryWrapper
, zig_0_11
, nix
}:

stdenv.mkDerivation rec {
  pname = "zon2nix";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = "zon2nix";
    rev = "v${version}";
    hash = "sha256-VzlLoToZ+5beHt9mFsuCxlSZ8RrBodPO6YKtsugAaik=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    zig_0_11.hook
  ];

  postInstall = ''
    wrapProgram $out/bin/zon2nix \
      --prefix PATH : ${lib.makeBinPath [ nix ]}
  '';

  meta = with lib; {
    description = "Convert the dependencies in `build.zig.zon` to a Nix expression";
    homepage = "https://github.com/figsoda/zon2nix";
    changelog = "https://github.com/figsoda/zon2nix/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
    inherit (zig_0_11.meta) platforms;
  };
}
