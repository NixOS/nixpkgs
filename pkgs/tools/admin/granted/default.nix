{ buildGoModule
, fetchFromGitHub
, lib
, makeWrapper
, xdg-utils
}:
buildGoModule rec {
  pname = "granted";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "common-fate";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5NEwd1SN+SwKMhbcgVBYbYsF1+H+xWx5zLl91eD9Ig8=";
  };
  vendorSha256 = "sha256-jO26atvv/PXvmx6wxpYaBtQREIi3b9Ne31RCG1b2b00=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/granted \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/common-fate/granted";
    description = "The easiest way to access your cloud.";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ymatsiuk ];
    mainProgram = "granted";
  };
}
