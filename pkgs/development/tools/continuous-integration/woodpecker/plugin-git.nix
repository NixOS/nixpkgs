{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "woodpecker-plugin-git";
  version = "1.4.0";
  CGO_ENABLED = "0";

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "plugin-git";
    rev = "v${version}";
    sha256 = "sha256-yKPWzHk7kbdFuRS+oO9iKFQUQbD1gJuaMAFVcL5elDM=";
  };

  vendorSha256 = "oIGYARXDVcFBxoapMGZMvcCYIc7LHHQIEhugDxRZeU4=";

  # Checks fail because they require network access.
  doCheck = false;

  meta = with lib; {
    description = "Woodpecker plugin for cloning Git repositories.";
    homepage = "https://woodpecker-ci.org/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [thehedgeh0g];
  };
}

