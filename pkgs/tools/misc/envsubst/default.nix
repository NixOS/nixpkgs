{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "envsubst";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "a8m";
    repo = "envsubst";
    rev = "v${version}";
    sha256 = "sha256-gfzqf/CXSwGXBK5VHJnepFZ1wB3WElpEp6ra9JI4WtY=";
  };

  vendorHash = "sha256-L0MbABgUniuI5NXc4ffBUsQRI716W/FiH38bGthpXzI=";

  postInstall = ''
    install -Dm444 -t $out/share/doc/${pname} LICENSE *.md
  '';

  meta = with lib; {
    description = "Environment variables substitution for Go";
    homepage = "https://github.com/a8m/envsubst";
    license = licenses.mit;
    maintainers = with maintainers; [ nicknovitski ];
    mainProgram = "envsubst";
  };
}
