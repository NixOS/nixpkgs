{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloudlist";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ad77nnhfx2l00nz9r89xfipwkvxp74y1xirjvkfxys4sf1yqag7";
  };

  vendorSha256 = "0yr9w2k6lyxnwbxh9mp1lri9z29wl9rgfvq8mjjdlqvcqhbw7l7l";

  meta = with lib; {
    description = "Tool for listing assets from multiple cloud providers";
    homepage = "https://github.com/projectdiscovery/cloudlist";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
