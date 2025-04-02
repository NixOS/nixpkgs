#!/usr/bin/env python
import torch


def opt_foo2(x, y):
    a = torch.sin(x)
    b = torch.cos(y)
    return a + b


print("Testing CPU")
print(
  opt_foo2(
    torch.randn(10, 10),
    torch.randn(10, 10)))

print("Testing MPS")
assert torch.backends.mps.is_built(), "PyTorch not built with MPS enabled"
if not torch.backends.mps.is_available():
    print("MPS not available because the current MacOS version is not 12.3+ "
          "and/or you do not have an MPS-enabled device on this machine.")

else:
    print(
      opt_foo2(
        torch.randn(10, 10, device="mps"),
        torch.randn(10, 10, device="mps")))
