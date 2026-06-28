{
  python3,
  writeShellApplication,
}:
writeShellApplication {
  name = "wgpu-py-triangle";
  runtimeInputs = [
    (python3.withPackages (ps: [ ps.wgpu-py ] ++ ps.wgpu-py.optional-dependencies.glfw))
  ];

  text = "python3 ${python3.pkgs.wgpu-py.src}/examples/triangle.py";
}
