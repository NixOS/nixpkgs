{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin {
  pname = "ros2.fish";
  version = "0-unstable-2025-04-16";

  src = fetchFromGitHub {
    owner = "kpbaks";
    repo = "ros2.fish";
    rev = "2d6d19f3b882f7b5f08707ae9d0a9a3fbc5ec13f";
    sha256 = "sha256-WWH2eyenMtIPxBs/EZCfag3IfeVZfwUREJYSIbnzFrw=";
  };

  meta = {
    description = "Integrates ROS2 with the fish-shell";
    homepage = "https://github.com/kpbaks/ros2.fish";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tetov ];
  };
}
