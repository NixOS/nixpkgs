{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  rospkg,
  xacro,
  mujoco,
}:

buildPythonPackage (finalAttrs: {
  pname = "xacrodoc";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamheins";
    repo = "xacrodoc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zuyd+lVcrz06yEgapoTjOZP+mxfOsk52rQE33aKV0qI=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    rospkg
    xacro
  ];

  optional-dependencies = {
    mujoco = [
      mujoco
    ];
  };

  pythonImportsCheck = [
    "xacrodoc"
  ];

  meta = {
    description = "Compile xacro files to plain URDF or MJCF from Python or the command line (no ROS required)";
    homepage = "https://github.com/adamheins/xacrodoc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "xacrodoc";
  };
})
