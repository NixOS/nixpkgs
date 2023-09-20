{ runCommandNoCC
, python
, torch
}:

runCommandNoCC "${torch.name}-gpu-test"
{
  nativeBuildInputs = [
    (python.withPackages (_: [ torch ]))
  ];
  requiredSystemFeatures = [
    "cuda"
  ];
} ''
  python3 << EOF
  import torch
  assert torch.cuda.is_available(), f"{torch.cuda.is_available()=}"
  EOF

  touch $out
''
